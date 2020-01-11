Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D05CB1382A8
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 18:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730648AbgAKRi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 12:38:26 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:43995 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730641AbgAKRi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 12:38:26 -0500
Received: by mail-io1-f65.google.com with SMTP id n21so5408982ioo.10
        for <netdev@vger.kernel.org>; Sat, 11 Jan 2020 09:38:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gco5z+Qg8agRB2LzTuEJRRXXHutWI/Hv71XtwaAsd5E=;
        b=VjNct2RVVgcWvqAVZb5BlIUQ4s2o5iRevRnpVQauk2qR++PUpwa5dR+7t2BzsTKzqS
         swxcHYWZVieC8L3/2ROC0d6pduKGYON8UuFPHZBVRSn8tsOVNhHYGD0ZxnGABB7eA9Fl
         0KP+4gFehmlaAhNrrehDXecgA2KN9VPl3KQm698Yzpj2C9PepzVYwCEQrn3tRc9BjXbo
         8PsrO/mnTd2XwD8v2DbbtEoOmfVmgvWTUCPMh9WcJmaGSYjOTzmENsq9zkRRzusHtvYY
         6xyRdBkDTfTGgn25Qg+i6d5seZRYgu5ISWdw4PRMWLLZ8jDrFhDHxW25L6jvlrch+36q
         NJCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gco5z+Qg8agRB2LzTuEJRRXXHutWI/Hv71XtwaAsd5E=;
        b=ImgCrFqzdbrfXb1vw4QYEf8g9v/txezXQ7pOQiQ7tjn+/owMuqE2gHwoxH40xR3cSl
         mLMwnTyqBkq7SjyvkE+GIhqOGA7FYyHmh4OvesiSZnbU2hSHK5uZNt7ztD9zd9z/tmXI
         21mGngnDdTBhCxBY+af0WUuo20zeNs6curoQIfI/vamCiUnXOHNdRkdEinqyWkCFY1Pc
         qJ5k3hx6KIg5FuOa+1SV4ZR33sUfDFX9MREbuPtWycEyO855bZBqM5jpdlTC9jqG1hxx
         Bc1QVecnxyq4nDJlcWgyZqlv0KGeDOrk6lOP65pLAOCQkA6668j4t/SnYk11VnTUhGMr
         Udpg==
X-Gm-Message-State: APjAAAVlZ9YT/EV0vdVceKzcrPOpohjPssPIRpxTlhbdMmYVuN/mFYhy
        B7cRhIjSKsYlmem8gdyyo+ulpaGi
X-Google-Smtp-Source: APXvYqwHTUIZnFAU8pn75Hq6RjiQAbbREIfopSnbGWNJoja28oBD6lI1mOzeWNaPPrNFCr4ZtK5uoQ==
X-Received: by 2002:a05:6638:76c:: with SMTP id y12mr8249647jad.95.1578764305806;
        Sat, 11 Jan 2020 09:38:25 -0800 (PST)
Received: from ?IPv6:2601:284:8202:10b0:9c36:c722:f45a:b2f5? ([2601:284:8202:10b0:9c36:c722:f45a:b2f5])
        by smtp.googlemail.com with ESMTPSA id i18sm1453318ioj.59.2020.01.11.09.38.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jan 2020 09:38:24 -0800 (PST)
Subject: Re: [PATCH net] net/route: remove ip route rtm_src_len, rtm_dst_len
 valid check
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S . Miller" <davem@davemloft.net>
References: <20200110082456.7288-1-liuhangbin@gmail.com>
 <49a723db-1698-761d-7c20-49797ed87cd1@gmail.com>
 <20200111011835.GG2159@dhcp-12-139.nay.redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c9369e95-4578-7d11-1dd4-ca8e45a70ef0@gmail.com>
Date:   Sat, 11 Jan 2020 10:38:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200111011835.GG2159@dhcp-12-139.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/10/20 6:18 PM, Hangbin Liu wrote:
> On Fri, Jan 10, 2020 at 02:48:03PM -0700, David Ahern wrote:
>> On 1/10/20 1:24 AM, Hangbin Liu wrote:
>>> In patch set e266afa9c7af ("Merge branch
>>> 'net-use-strict-checks-in-doit-handlers'") we added a check for
>>> rtm_src_len, rtm_dst_len, which will cause cmds like
>>> "ip route get 192.0.2.0/24" failed.
>>
>> kernel does not handle route gets for a range. Any output is specific to
>> the prefix (192.0.2.0 in your example) so it seems to me the /24 request
>> should fail.
>>
> 
> OK, so we should check all the range field if NETLINK_F_STRICT_CHK supplied,
> like the following patch, right?

a dst_len / src_len of 32 (or 128 for v6) is ok. It still means only the
prefix is used for the route get. That's why it was coded this way as
part of the change for stricter checking.

