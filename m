Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5ECA4D774D
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 18:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235162AbiCMRfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 13:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiCMRfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 13:35:08 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8883B8092E
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 10:34:00 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id rm8-20020a17090b3ec800b001c55791fdb1so4649397pjb.1
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 10:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QvUbozeaUHCFBS5Vvf2ot1GZ8Mqq1/egfgP6OS6EtP0=;
        b=PQDR+4OnIlt5yEsqQuHKD/bSF3PhEhjsmp5u5IVWkZH6eZhg+7c1hKAsq920T4zWIb
         GLyh5chMPbfSB+mLoIgS3b8KRjE6unnvYc80eCLmSmNEQylP9bx8utxQHRAZmrppYd43
         gc7SEspfynvQ/xrXuTVwpBfQABeaPWF3LeMX/9EbCBfBcE/zhqiqe5D4FCZFhVMIqWQV
         VHSl+raJJWTs60JKoHypO0K/aHeqT1ksjxybQ9c/9btaYGtilQwiAiaeLivaLk2uvfG1
         EFXZuY06F2XLKdHKgadPgp5i88VA1tKY/7jaotH1X6CebWfubAto0fPKCEHHUq8kgQa7
         BZFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QvUbozeaUHCFBS5Vvf2ot1GZ8Mqq1/egfgP6OS6EtP0=;
        b=QHvn0OlD50BHkQX89jZ1bbBDTQaz/kxiY++hXaq3yGGi0G0GV5nNUTVC4Zjh1JSykB
         bUsnUlgTL4qdutbkPecON/ciuconecg2B9uVEk2wWSlJ8KxR/36QcEjONR9DTiVK5s4F
         qZubUSp4ewSDVzw01mBfaDZBDxtfeKkyIiJblSL65HBZuxx8vxJ1opWTK/QnA73TvN4z
         vjduh2YoS9LhPLIwmZzpYZFcahq2aZbwcsyri1vHqS3JEIwYbkKbFi9j8FMdx3vvC1VL
         xSjWPw4INtvvILspppgxpXusdOMio25LCH9Ex05vfq7AVZ1eEwOJUUxppIbOKYyCNgXx
         ybrQ==
X-Gm-Message-State: AOAM533NyNibeC8hoyy6MeVZFYQ6KjC4HPeNOu+tC4Ett7mSgjeTeY0/
        QuhpFhWB9BHuveX/YNIXAYuNgA==
X-Google-Smtp-Source: ABdhPJypZMkXJz/A9qMDfnKfqu0PWEEr8ND5T7iIrWsz38Ght+QO8RZCBgn204ap+UOyuFcAUht6Kg==
X-Received: by 2002:a17:902:ea85:b0:153:563a:a8be with SMTP id x5-20020a170902ea8500b00153563aa8bemr4971033plb.9.1647192840024;
        Sun, 13 Mar 2022 10:34:00 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id m19-20020a17090ab79300b001c5ddc6ff21sm3052872pjr.8.2022.03.13.10.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Mar 2022 10:33:59 -0700 (PDT)
Date:   Sun, 13 Mar 2022 10:33:56 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Eli Cohen <elic@nvidia.com>
Cc:     <dsahern@kernel.org>, <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>,
        <si-wei.liu@oracle.com>, <mst@redhat.com>, <lulu@redhat.com>,
        <parav@nvidia.com>
Subject: Re: [PATCH v7 2/4] vdpa: Allow for printing negotiated features of
 a device
Message-ID: <20220313103356.2df9ac45@hermes.local>
In-Reply-To: <20220313171219.305089-3-elic@nvidia.com>
References: <20220313171219.305089-1-elic@nvidia.com>
        <20220313171219.305089-3-elic@nvidia.com>
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

On Sun, 13 Mar 2022 19:12:17 +0200
Eli Cohen <elic@nvidia.com> wrote:

> +			if (feature_strs)
> +				s = feature_strs[i];
> +			else
> +				s = NULL;

You really don't like trigraphs?
			s = feature_strs ? feature_strs[i] : NULL;
is more compact
