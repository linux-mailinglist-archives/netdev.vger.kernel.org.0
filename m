Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0CE4F99B9
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 17:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237731AbiDHPpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 11:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbiDHPpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 11:45:02 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4E78F984
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 08:42:58 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id t4so8111721pgc.1
        for <netdev@vger.kernel.org>; Fri, 08 Apr 2022 08:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NdD/NmViCDgpdSszkXJoNveKWkNOGxWJWR0WjtMVdYI=;
        b=QoZNgyQrF7Sbldvdc8pxZdgpn8BVS4KWwPxRyMESjhipBZInRS9naTskan+s1UNgmM
         d/kpFHC7qL2CZTeMuA7KG7e3cjAYQTtCUPw8gdqkZOUGBlI80mn8/aBHZNNV+XWth6FR
         lKenlPu3TwFgpHQDZymtZJtfgPeGeAdCqwI5JYm0rNEjO/ZZfp3o4dUMChYY5DGf1VKe
         KNfVtQ2ha7H4DyX5qCwaei/jNrHbs0sC3zRVRN7bFU6BmghGZsioky4z7k4T2ihApinz
         ZHUU0/3pzwYkhQT1cqjsIsGzKpZE7x5jGrPEOZaNwE2MC5JimYzJbRr/DNOFngF/TXNt
         3TsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NdD/NmViCDgpdSszkXJoNveKWkNOGxWJWR0WjtMVdYI=;
        b=3riDg8aYOqRCp+9h/bL0kzG+ORFhOFdPNefeNDBG22R0MHffmmh1ZzzYoshxLTzzPC
         u0FdQsoRReTcynW1Pm7E34MPfu7MLaK0NA6GTzRKY6hg6dgYPiYF5fNgFOvhuME9sk5a
         2Ule1+84maZQLcHnMwsHZzrbUI8LWVFwXU+57UPFpbMfTG4Mk0k0MYNumkesqCX3mmEk
         QgyiqeFAc/96cTLDFyGpiI0sjocdX+It21uMGoOCTuF1XEblhA9fnV8ZfzPAbbbOmdUX
         9iB1aF5nivdf9evzChtoFjApA2kuMZDTJe9R8YsFH6lxQFcox7q7Eh2m453y/iUnEcbQ
         ZXVQ==
X-Gm-Message-State: AOAM532vRWB+2EUZ5k7OGwo5mDHzvrzLK9ed6p2MaggrInorEhXSdWI1
        5Dg9v4/WlXGO94CZlQ2UB3AJ29mJxlO3cg==
X-Google-Smtp-Source: ABdhPJwH+ROCaYaDf4vrwrBBiMqw7b6AH7ikHi0Ja3YegMQtTGJqlkV55KDWv33v695N8Dcw6plKRw==
X-Received: by 2002:a63:1063:0:b0:39c:ec64:c062 with SMTP id 35-20020a631063000000b0039cec64c062mr5005051pgq.601.1649432578372;
        Fri, 08 Apr 2022 08:42:58 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id a7-20020aa79707000000b004fb17ad3aefsm26098549pfg.108.2022.04.08.08.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 08:42:58 -0700 (PDT)
Date:   Fri, 8 Apr 2022 08:42:54 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Max Tottenham <mtottenh@akamai.com>
Cc:     <netdev@vger.kernel.org>, <johunt@akamai.com>
Subject: Re: [PATCH iproute2-next] tc: Add JSON output to tc-class
Message-ID: <20220408084254.72ab9b50@hermes.local>
In-Reply-To: <20220408105447.hk7n4p5m4r6npzyh@lon-mp1s1.lan>
References: <20220408105447.hk7n4p5m4r6npzyh@lon-mp1s1.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Apr 2022 11:54:47 +0100
Max Tottenham <mtottenh@akamai.com> wrote:

>   * Add JSON formatted output to the `tc class show ...` command.
>   * Add JSON formatted output for the htb qdisc classes.
> 
> Signed-off-by: Max Tottenham <mtottenh@akamai.com>

LGTM, if there no objections will pick it up for this release.
