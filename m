Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF3243B4F3
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbhJZO7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbhJZO7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 10:59:38 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B88C061745
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 07:57:14 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id a17-20020a4a6851000000b002b59bfbf669so4910225oof.9
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 07:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sZ5mUbjveLENEO7EvGITMF0N2WD08b9h6WednCtw9Sg=;
        b=qxXsLtQiosc0BY4yFJZj7NzEl/xbnHka1SlDl+l7oeLXJzBPwHfvk9xqZ9/KLkEOC0
         WRJqNi/jwTXnvsYQtssFjQFz8UzxfjgHc6RE0gznAx2FmPFpgC/33FvgftCC6rw13lgS
         0tTDbellhRNfTu1wDA87nacQybau7NLKX/G052mC4efXubD4NSQ01xQT0hIsd2F0qalM
         P0fhAHwc70N8efhMYiGTGxmjjQdmMhze09rfaXOiTG9+y8CVwUi1F0Wn66yKVOzyxpc5
         SlwlkD0sUWEIJE6Gk4qKW4gAc4XenxKvTBhfN42BRl9dX7lS3BMhx1bwsmjvRdIyhq9O
         MJoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sZ5mUbjveLENEO7EvGITMF0N2WD08b9h6WednCtw9Sg=;
        b=dtEMroPCE3ZmCVt/qElGCxRyPJfdkgrrGMhcyZphDA8vRX8iGsu6crZCNUf8hRwTKi
         zfEa82xMdmDuSCZGLW7nExUKuWBDDHqWYAss89yfc6wK4L0f0TnQLmwYlp0fJg7CBkgf
         WH3rRUKW6lMsNg0uJGPfUFTP9A8VD1FvLNyYvYjFf0mHyk6y06fh2Z2Cxc4ortK+PIDa
         j+Mkb+2xhbfFwmk+xSIiXogL5j8JmO55QWFl3yrYfsuDPgdQVUWMLkKy3JPJ23BPijoL
         1CEQ7Hev9XDKzNsa14gI6AaKZyY8WWBadBo3FOK3qRaAsrV62i2on4GxZ50f6L7QQy9m
         ftSQ==
X-Gm-Message-State: AOAM533ZnNrjyPG1K3CQ2AGgEPrZbVdPS59Q9ThjUj0nQDUVMsp5yumF
        VyZNC3LUuCe71iV357/LhBw=
X-Google-Smtp-Source: ABdhPJybd/mkz9B2/8hfl5DYRU5VoBrSVtdmmVTOJ8iuCII9E/xvtBX+2lLaqgIKvnuw/KxxusMiMA==
X-Received: by 2002:a4a:c883:: with SMTP id t3mr17773080ooq.58.1635260233757;
        Tue, 26 Oct 2021 07:57:13 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id n7sm4560399oij.46.2021.10.26.07.57.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 07:57:13 -0700 (PDT)
Message-ID: <ea4d34ea-6393-97c9-5484-f703a4f5cea6@gmail.com>
Date:   Tue, 26 Oct 2021 08:57:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [RESEND PATCH v7 3/3] selftests: net: add
 arp_ndisc_evict_nocarrier
Content-Language: en-US
To:     James Prestwood <prestwoj@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, roopa@nvidia.com,
        daniel@iogearbox.net, vladimir.oltean@nxp.com, idosch@nvidia.com,
        nikolay@nvidia.com, yajun.deng@linux.dev, zhutong@amazon.com,
        johannes@sipsolutions.net, jouni@codeaurora.org
References: <20211025164547.1097091-1-prestwoj@gmail.com>
 <20211025164547.1097091-4-prestwoj@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211025164547.1097091-4-prestwoj@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/25/21 10:45 AM, James Prestwood wrote:
> This tests the sysctl options for ARP/ND:
> 
> /net/ipv4/conf/<iface>/arp_evict_nocarrier
> /net/ipv6/conf/<iface>/ndisc_evict_nocarrier
> 
> Signed-off-by: James Prestwood <prestwoj@gmail.com>
> ---
>  .../net/arp_ndisc_evict_nocarrier.sh          | 181 ++++++++++++++++++
>  1 file changed, 181 insertions(+)
>  create mode 100755 tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh
> 

Thanks for adding the selftests.

The tests should include a set with the 'all' setting as well -- off and
on works as expected. If you have to do another version, you can add it
then. If this version gets committed, please send a followup patch with
those tests.

Reviewed-by: David Ahern <dsahern@kernel.org>
