Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81E08184C06
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 17:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgCMQIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 12:08:32 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39319 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbgCMQIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 12:08:32 -0400
Received: by mail-wm1-f68.google.com with SMTP id f7so10902801wml.4
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 09:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ml2P3KKWTpFi6kw+xt/cwO8aUdMFrLyTs/rPNyzYSC0=;
        b=bWFjqSu5CueE8pD/VvBvDz6h91SqkQqHDhgFS5tH1oJ2Q/AS6pSEI5Ugq02XTDRl1Q
         SaP444QlFsjauPkEyJy6EhioFjyRQcHJsorL5W61T70uKxQjcEpe5c5AIDySWbd8zIW7
         ZSwvm7S4GkwchgYFrC3bM0R8SlSrDwVL9ky/fN7F+GzCABne8KKA8dUE41+4SLK5CGVd
         XePffyIvigIagtSh4ljE5B8wORlqPa28WpshchAk8HALhBrf0jcAh+YKAoRvNcSs6b9b
         LW0vhCttmyCeHEzyofN0GzQztNIcRgZIAcO1l4p8SbYw/Aq+3sGEpUNJrNxRexNv332r
         AjSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ml2P3KKWTpFi6kw+xt/cwO8aUdMFrLyTs/rPNyzYSC0=;
        b=S3azEX6Ihgmmb0g7jYkwLeKI0PmEIyskXWbae+35Kl2e5ohZji8oWgU4db7GIyMJPD
         Zz95RlMCEOF06Er4hmA+79BIMQR0RvsnQVaK99x/oFiKAMm0SV8hTvnEjPDxjap3azlX
         qZ2YyXk8ja6P3oORBA4VjV+pBPOVtCClrHqDimiWGjfdm4/kzQnZTUPeHQKTB9v27yFr
         70e+3/BSy4bTGTrv08yH64qCWElfv2ZQiNJzl+hyGIjOE2STefqdaKUddm8SQuaKEA3K
         pzLqfFbIA04aWjozufqqoqAyD5hlfCCoWgDTvWNFHDVZtKUuVe6DdTSd88rKRQhcB2UM
         fsvw==
X-Gm-Message-State: ANhLgQ3UQ5A9p5Kt4bK10669Ks3d/twj+Zb1Nd6QteSwqeqFfL+khduE
        zbbhbuN/NItiCDJ/FIu0VKkTrw==
X-Google-Smtp-Source: ADFU+vsHGDvfauS7DYG2WcqdbqzkgWf+vbceuxTPS17BWDYmI36UETrEGgQ4IHWQx4dmFMdnfBzBVw==
X-Received: by 2002:a1c:750f:: with SMTP id o15mr11753406wmc.145.1584115709404;
        Fri, 13 Mar 2020 09:08:29 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net (81.243-247-81.adsl-dyn.isp.belgacom.be. [81.247.243.81])
        by smtp.gmail.com with ESMTPSA id v14sm44024671wrr.34.2020.03.13.09.08.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2020 09:08:28 -0700 (PDT)
Subject: Re: [PATCH net-next v2 1/2] mptcp: create msk early
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
References: <cover.1584114674.git.pabeni@redhat.com>
 <6a63634eeffdc7930755fcc1e46e93fb687ae380.1584114674.git.pabeni@redhat.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <5b85c12a-ddae-a8f6-e4ec-047b0fc6f28b@tessares.net>
Date:   Fri, 13 Mar 2020 17:08:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <6a63634eeffdc7930755fcc1e46e93fb687ae380.1584114674.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/03/2020 16:52, Paolo Abeni wrote:
> This change moves the mptcp socket allocation from mptcp_accept() to
> subflow_syn_recv_sock(), so that subflow->conn is now always set
> for the non fallback scenario.
> 
> It allows cleaning up a bit mptcp_accept() reducing the additional
> locking and will allow fourther cleanup in the next patch.
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

LGTM, Thanks Paolo!

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
