Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5A631BBD8
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 16:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhBOPGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 10:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbhBOPE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 10:04:56 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4BFC061756
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 07:04:16 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id v3so1111362ota.2
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 07:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=G0gwcn6qAGMnofUVZqYh0t6M0oTaA/yVPeUFozTmCWE=;
        b=OeZOZYMhooR21du2vshlfV4OpbVeGu8cbz1nv+1uFJpgUCqylY4FSqi/+6HHi9nDc5
         Ys4rtNGj1wm3WWM6c+rIozInd9lfjLF0C6K8pAhGTCY7J4UBH0piKhiTbcK7hcyUP13M
         Rqoe5MCGjwUXKkt9X1dBPeYpKuhIvCHAh1/dDMCmzLozEJL9ydAV9OJO/OoxeDvnIA1F
         xJx9KFcva+sHvQD8DM+HX//syWwBITIVDnIo/yOtDxGIXEP8x5eslbdemxVDM4j5ECKg
         1i9CkiCMl354SJzyo99b6kKr/1MLV1yju5FhCDulP7o6UnEF4I+hmYlnPkEtNdUBlEJB
         M7aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G0gwcn6qAGMnofUVZqYh0t6M0oTaA/yVPeUFozTmCWE=;
        b=QR0O9izdg10uvpD9QJvl/SmzIilZK77Hp4k+OVpgDRMCbJTt8T5VAe7cXE43b6XeiI
         sjuoRIApSAvVDhJYpuETM+7vcP7ujZ6UVvdYjB0xKwpQCos60+0m668yJi0hrgsPwiLL
         SnawKv7ptX8wS2VpRaQZPLQl4fCykbHE/tW/hLPDO85xIBh+jBIkc45xYIdFbDaBZuw2
         OVozUMzo/QNNGTRJjJL5N9q28p2+3Ehx6Mwo8vWMcM49chQ02Dvv2VFmVV6MWAP7aVU8
         K4wDZe6Rc9BWUZFHGOQEOidgmsTA7IY0NAHq815y1n2PwIWhsYLoA3dnmGICOrneaaMT
         MSrw==
X-Gm-Message-State: AOAM5316qRMA3XpyLylhnGiIe0ODnFcKL0MG4wyO1MKHrgLRlcedE7Wk
        Rn59aSxAcs/9PpqR5GOPSYJDsaofxCGkLA==
X-Google-Smtp-Source: ABdhPJy4PckBRJGmX7XbAdiWVwNXtiTDw+hhIrVC3TwZXV3lk3olcsNqZLb/xAq3b8d8T7nZO/47rQ==
X-Received: by 2002:a9d:312:: with SMTP id 18mr11799482otv.186.1613401454636;
        Mon, 15 Feb 2021 07:04:14 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id o83sm3382371ooo.37.2021.02.15.07.04.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Feb 2021 07:04:14 -0800 (PST)
Subject: Re: [net-next] tcp: Sanitize CMSG flags and reserved args in
 tcp_zerocopy_receive.
To:     Dan Carpenter <dan.carpenter@oracle.com>, kbuild@lists.01.org,
        Arjun Roy <arjunroy.kdev@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     lkp@intel.com, kbuild-all@lists.01.org, arjunroy@google.com,
        edumazet@google.com, soheil@google.com,
        David Ahern <dsahern@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210215120345.GE2087@kadam>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <33d68f94-2d20-fdc4-c572-16138aa6305b@gmail.com>
Date:   Mon, 15 Feb 2021 08:04:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210215120345.GE2087@kadam>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/15/21 5:03 AM, Dan Carpenter wrote:
> Hi Arjun,
> 
> url:    https://github.com/0day-ci/linux/commits/Arjun-Roy/tcp-Sanitize-CMSG-flags-and-reserved-args-in-tcp_zerocopy_receive/20210212-052537
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git e4b62cf7559f2ef9a022de235e5a09a8d7ded520
> config: x86_64-randconfig-m001-20210209 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> smatch warnings:
> net/ipv4/tcp.c:4158 do_tcp_getsockopt() warn: check for integer overflow 'len'
> 
> vim +/len +4158 net/ipv4/tcp.c
> 
> 3fdadf7d27e3fb Dmitry Mishin            2006-03-20  3896  static int do_tcp_getsockopt(struct sock *sk, int level,
> 3fdadf7d27e3fb Dmitry Mishin            2006-03-20  3897  		int optname, char __user *optval, int __user *optlen)
> ^1da177e4c3f41 Linus Torvalds           2005-04-16  3898  {
> 295f7324ff8d9e Arnaldo Carvalho de Melo 2005-08-09  3899  	struct inet_connection_sock *icsk = inet_csk(sk);
> ^1da177e4c3f41 Linus Torvalds           2005-04-16  3900  	struct tcp_sock *tp = tcp_sk(sk);
> 6fa251663069e0 Nikolay Borisov          2016-02-03  3901  	struct net *net = sock_net(sk);
> ^1da177e4c3f41 Linus Torvalds           2005-04-16  3902  	int val, len;
> 
> "len" is int.
> 
> [ snip ]
> 05255b823a6173 Eric Dumazet             2018-04-27  4146  #ifdef CONFIG_MMU
> 05255b823a6173 Eric Dumazet             2018-04-27  4147  	case TCP_ZEROCOPY_RECEIVE: {
> 7eeba1706eba6d Arjun Roy                2021-01-20  4148  		struct scm_timestamping_internal tss;
> e0fecb289ad3fd Arjun Roy                2020-12-10  4149  		struct tcp_zerocopy_receive zc = {};
> 05255b823a6173 Eric Dumazet             2018-04-27  4150  		int err;
> 05255b823a6173 Eric Dumazet             2018-04-27  4151  
> 05255b823a6173 Eric Dumazet             2018-04-27  4152  		if (get_user(len, optlen))
> 05255b823a6173 Eric Dumazet             2018-04-27  4153  			return -EFAULT;
> c8856c05145490 Arjun Roy                2020-02-14  4154  		if (len < offsetofend(struct tcp_zerocopy_receive, length))
> 05255b823a6173 Eric Dumazet             2018-04-27  4155  			return -EINVAL;
> 
> 
> The problem is that negative values of "len" are type promoted to high
> positive values.  So the fix is to write this as:
> 
> 	if (len < 0 || len < offsetofend(struct tcp_zerocopy_receive, length))
> 		return -EINVAL;
> 
> 110912bdf28392 Arjun Roy                2021-02-11  4156  		if (unlikely(len > sizeof(zc))) {
> 110912bdf28392 Arjun Roy                2021-02-11  4157  			err = check_zeroed_user(optval + sizeof(zc),
> 110912bdf28392 Arjun Roy                2021-02-11 @4158  						len - sizeof(zc));
>                                                                                                         ^^^^^^^^^^^^^^^^
> Potentially "len - a negative value".
> 
> 

get_user(len, optlen) is called multiple times in that function. len < 0
was checked after the first one at the top.

Also, maybe I am missing something here, but offsetofend can not return
a negative value, so this checks catches len < 0 as well:

	if (len < offsetofend(struct tcp_zerocopy_receive, length))
		return -EINVAL;


