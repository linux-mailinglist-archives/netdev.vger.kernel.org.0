Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D7922BA34
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 01:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgGWXYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 19:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbgGWXYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 19:24:23 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6487C0619D3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 16:24:22 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id d27so5721436qtg.4
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 16:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JAu9G1UGe0GbiyPdkP80pOzILgNtX0t2pGvNYGcMHes=;
        b=GO7FnUDVAKUS5EFar1eH5xCgukGuRoCu+fHbmwInBoFodW6/ocCOAxNeL6DTWUxXTE
         sOKapiq82QKu/SYeT5DEj1KsmhCeP9HWjMWJENMyCkUtXN1GaEVdh9XHUi9m0I1A5ASJ
         bMwgYFA3OdMsizX+tgibCQnAa9Htk6SnvQ5aASOosL4TDltypXsNim8n0T3Q+5DLdaoD
         sXKT//v8bkvQ9VVTWJ55F+taqIfgZRYPnD1ZU16aHanqO6FC3jf1bADK5VJBqHXrOutl
         +ECVNo466Sflopq93bGIieSXnzqUUzjINWWrbHOHesKvbFFHR8B0uUIwP3Kq+Y2X2tK0
         MrYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JAu9G1UGe0GbiyPdkP80pOzILgNtX0t2pGvNYGcMHes=;
        b=kxzUcWUd9AmCr7Gicg1ABm/CFthGkexgKBwIfevG1L4bHRW3FX+JTNXLYj1rRQm3M2
         SSL1XJiwDRM96W857h2+AuGMyQdOJCOhcHp43o0lOSMUNHn2Y2MwvkK+h6CdSWwymHua
         D43CBQmNHlbfh+4bKDHld8WggApk3i4MstuRLet3DOeX2oQYLAn2BB+ZoAiExVAf+5kI
         n6ODLdP+YLgcyBJQHq45Z1GRclaJJZap5PWyV8ZQWItvmo2++rTpfMQNFHYtup6A7Yi2
         snSOi1qX4Iykk9Z0M+dl+WwZYlydnQIf+0WvFY8DC9YZ6HAaxYo4sJJ5FbZJaN12ljCu
         Bwqg==
X-Gm-Message-State: AOAM532/9wfrsaiAHFRBU7sQPA097olR4jpMTnm8dEX/w/eSTk5Z0v5/
        Q2ne9qNF8pMoog05KvSURMY=
X-Google-Smtp-Source: ABdhPJw+aNHO735Jc7PF5iS1dfQif+PilGDMM1eJ85futGx7sbF6dR42m794L5N+ox0VdUSs3rnvtg==
X-Received: by 2002:aed:2f87:: with SMTP id m7mr6726280qtd.56.1595546662161;
        Thu, 23 Jul 2020 16:24:22 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:60ab:1137:3250:7720? ([2601:282:803:7700:60ab:1137:3250:7720])
        by smtp.googlemail.com with ESMTPSA id r35sm4141645qtb.11.2020.07.23.16.24.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2020 16:24:21 -0700 (PDT)
Subject: Re: [PATCH net] vrf: Handle CONFIG_SYSCTL not set
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net
Cc:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        Randy Dunlap <rdunlap@infradead.org>
References: <20200723232309.48952-1-dsahern@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8436b75d-da73-685e-16d3-d4d3fce298de@gmail.com>
Date:   Thu, 23 Jul 2020 17:24:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200723232309.48952-1-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lost track of time for this commit. This should go to net-next, not net.
Sorry. I can re-send if necessary.
