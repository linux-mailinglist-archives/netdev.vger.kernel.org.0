Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6593F8ABE
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 17:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239162AbhHZPMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 11:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234068AbhHZPL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 11:11:59 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DC7C061757
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 08:11:12 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id z10so5153792edb.6
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 08:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=96yCyM9REXtD0hJBDBgUoztJyOkc3A7AFrlt2K6ZlmI=;
        b=J14dq40YtChw9gqvxSX/HIWOsyEssLqldDZP2VygjM1jpd7WPXwn6SpQIayEo+f5uq
         xd/DUncsHB+kpF9PcRPdXj6Yq+erzM6XJPZ/LQMJ5WN8bPlbWPQRtMBzUXtPxcQj8W+R
         3+Yks/hLqsw+oXvGeDzRqSVyj5zO3mPehYnA+99/53j9NpR0o+yBZEbxBwxV8JfY14Yu
         NqusqLKP81jh9ETQBCi1VOOT4tiDPRRqRW1NMzMaH8kSGOCmSgJ0bDSQwdNObvXTckeP
         nkwshEMv84/NtlamAxsikiP0DVj3vTFXAmb+tv5j1IBSorB8RnjvW6S00zt1Vve/TanM
         gckw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=96yCyM9REXtD0hJBDBgUoztJyOkc3A7AFrlt2K6ZlmI=;
        b=WhnlCAUyxwo9cmw7jMxqWvKWwqZycMOtXg/CNO3Yc03vCM9ntf94C6/eDInzmaPRdh
         ZtWcnhfHhmkCeyToVpluSla8U6k6s0flWK0lSatnl+/3c4hYc+LS0wrE1G5fAaYZkMN3
         f/yJqN0jzUltNrCphzfHXd2xXowGPZeh3VRzTmj8hKLnpBNIlp6oQEAD+wbEMjzOefCR
         mr3k+WkH5h6bRr8rW4IY9kjgq+zDiKquJOjlErSMw/NMnZrcOCROzXkZr3o/mgM/R9AB
         Jct7RqBqa8su9QoUFiu9pChTR+IXfIgKRGvwpXB0VRgUdpHfagoEdFPrbZdnxmem4pu1
         jJJw==
X-Gm-Message-State: AOAM533NCZDIq5Uo/h4psngEdWEcpNKyDBopdiT7f0rRF5JxRXvvzm7E
        AgqtD8pdT+sRak1+FDH+Nw3UsQ==
X-Google-Smtp-Source: ABdhPJzeHsFf0MjIbAX0ULcxTd4sI3A4+SvbfEQgyBSd70Pd7AX+SqZNfFXT6R1ql3RE1Ep56cfWvQ==
X-Received: by 2002:aa7:cf82:: with SMTP id z2mr4825038edx.254.1629990670464;
        Thu, 26 Aug 2021 08:11:10 -0700 (PDT)
Received: from [192.168.0.111] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id v24sm1810463edq.79.2021.08.26.08.11.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Aug 2021 08:11:10 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 01/17] ip: bridge: add support for
 mcast_vlan_snooping
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        Joachim Wiberg <troglobit@gmail.com>, dsahern@gmail.com,
        Nikolay Aleksandrov <nikolay@nvidia.com>
References: <20210826130533.149111-1-razor@blackwall.org>
 <20210826130533.149111-2-razor@blackwall.org>
 <20210826080851.1716e024@hermes.local>
From:   Nikolay Aleksandrov <razor@blackwall.org>
Message-ID: <3594d516-288c-d84e-83ec-91c5288b452c@blackwall.org>
Date:   Thu, 26 Aug 2021 18:11:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210826080851.1716e024@hermes.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/08/2021 18:08, Stephen Hemminger wrote:
> On Thu, 26 Aug 2021 16:05:17 +0300
> Nikolay Aleksandrov <razor@blackwall.org> wrote:
> 
>> +		} else if (matches(*argv, "mcast_vlan_snooping") == 0) {
>> +			__u32 mcvl_bit = 1 << BR_BOOLOPT_MCAST_VLAN_SNOOPING;
> 
> Using matches() is problematic.  since it will change how 'mcast' is
> handled.
> 
> Overall, bridge command (and rest of iproute2) needs to move
> away from matches
> 

Sure, I can send a follow up if you don't mind to switch all matches calls. I used it
to be in line with the current code.
