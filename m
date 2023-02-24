Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E7C6A214D
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjBXSSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:18:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjBXSSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:18:36 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4742B42BC1
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:18:32 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id cb13so8406102pfb.5
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a72daFQJ3SSSzThy7egxDJOvu4mJ7r6EJfLJC/7O1xM=;
        b=fF7RwIjGaeoEN16yD1Ci2ghGZyQD5MAb5p91MOo2ZWjkkbvGFouGVnCqfVG7+qMas3
         ydS1QxvHIdJQHuMAafIOHDqqT0R4PW5aBytX8silGKLSm4MKk+1LL2Qu1tggqNsvpEb7
         sdFUBVQpAFxhQ/S4HSCMj7CWvkqgnQ1BGmr3C3te9u76cJCe0GtAU17lkc4KCk1xZH1J
         nMODixkRSrSqDj80E1gTA9bAza4N6M42lwrbVbZiH8h24N0kGWRt7Pz7zeqMdwb37Jig
         3RWe+RmQVzKofZvmMatQIsL6cmyZDsmDGHGvNUvrUAOHQZxIsAWpxNLL83B0eR9OAF5f
         6OJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a72daFQJ3SSSzThy7egxDJOvu4mJ7r6EJfLJC/7O1xM=;
        b=AKoxsDeRcA2nwTFFE+C79w6h+KidH8qclch3Mx/6gKg34PcVq1MHZfBFCzSwickPnG
         NoiDHCLBljnabBojIGt8nXcKUFGa66yBhL2z24f0wcEcgLJ3cl5ALkdbheD5jxCSy4k2
         PB3a3Fpgxwox0wYPcDklr7Lypv39VuRGnJiuTWkN+diE9aMLUl9C35zzzjac8BdgtH2w
         yeArGgAo7u3vuSPEt+ERiMZwIy48IO1rUAF+RR9LczKCXwJDxcUH4T5hOt5NmcwKa2oF
         ZS22Kb7aOroRNrLt5Q/aKW2fZTy8xNeOncUOPBcS5M6aXkISZPu8AF2DUpsnJhDPbcT3
         MEzQ==
X-Gm-Message-State: AO0yUKWrHURHtEMy/btv7eGq7vgGy00YLPzw9ZLXH/z+nvsN18eXUnm4
        Z5ohYR6mvvb21OXJlDR4v5e54nr0D2Pm3ZNmjfg=
X-Google-Smtp-Source: AK7set+Dq0P+sgfzv8IEMJYO7VB/hF2a5d21DdrkykTHMI3lpnGCwVfGEAfwiRSh7olL6uQmp2e64g==
X-Received: by 2002:a62:840e:0:b0:5a9:cb6b:7839 with SMTP id k14-20020a62840e000000b005a9cb6b7839mr16466263pfd.1.1677262711557;
        Fri, 24 Feb 2023 10:18:31 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id f15-20020aa78b0f000000b005ac419804d3sm8964137pfd.186.2023.02.24.10.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 10:18:31 -0800 (PST)
Date:   Fri, 24 Feb 2023 10:18:29 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Re: [PATCH iproute2 1/3] tc: m_csum: parse index argument correctly
Message-ID: <20230224101829.58c5e6e5@hermes.local>
In-Reply-To: <20230224181130.187328-2-pctammela@mojatatu.com>
References: <20230224181130.187328-1-pctammela@mojatatu.com>
        <20230224181130.187328-2-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Feb 2023 15:11:28 -0300
Pedro Tammela <pctammela@mojatatu.com> wrote:

> +			if (matches(*argv, "index") == 0) {
> +				goto skip_args;

No new uses of matches allowed in iproute2 commands.
