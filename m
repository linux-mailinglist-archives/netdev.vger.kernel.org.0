Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C70EC634E32
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 04:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235349AbiKWDF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 22:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234815AbiKWDF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 22:05:56 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C8620988;
        Tue, 22 Nov 2022 19:05:55 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id j10-20020a17090aeb0a00b00218dfce36e5so831704pjz.1;
        Tue, 22 Nov 2022 19:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h/DT8Tsx8DIu9iEaXlUevbHFz5d0eaRwUCxu0TgMFLQ=;
        b=QErisZ5ngzLLOAssodOOa1A9BMRC3TwAn5CaOpfA1G5xAO2hGlrRcJSkL726tA4cfL
         RdApdi+9ZeACb6OMF9k85iYiKuRBGG6WJIgbOMiHWsL+qeZLL82nG9I/pmlQzjoOGsFs
         DFQhnjCkZEgSTMDv3yERc4kUg4kliS3PmxHZXWvPP10HX5h3q5XS0ulF9huo+tXiIMs/
         CRkHzPg57INi/JvgVO1RrcqbxIZtJWSALI6kEvgbT3JTKOhYzEogfU4nT2CYm6B81l/a
         Un3pBgP2w0J6s0TWzigEwAN1MtRiGddwJ8NIvZ0j+8Pjx3Q3jZxJIXHGdwsJTvnuEplj
         xaPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=h/DT8Tsx8DIu9iEaXlUevbHFz5d0eaRwUCxu0TgMFLQ=;
        b=C38FprN/HGZ49N3VXagngG5Hv8htsrFGwMj2Ukk1hgTcTI2QncrNOUJ9h5D6axB5wX
         jvVUaOKf+2iWtp6UXuDVdAE8JDb8xQaXMPOFnj9mgb2bDNY2ds1q3eDJz1NE4KXyprgO
         wTGP7RPqoVyt3CDFgv+30CgHYgjx3scZq5CCwsdvKTjeYJRrRjQP1ZbXCBDM28NMlLku
         HQL50es7aaBhbl93PPzFQWfcHtPxgDU8dNP+yyTguzMKjfmK4Gkw70KQMazRu7dCMHAI
         pSzU+7u0Iu4Hn3eqKQVoe0efKyspCcqgqYAxOK8uMCkzG+Tm4LA5x+Ruw7B/cDfEAn4t
         akow==
X-Gm-Message-State: ANoB5pnaiacWB3oUlILLFl+YE8I6J22pKoXCYX3Ca+Z7ACcVrd/1UCgb
        /UAjhwfiVSeztqy8p46h9lc=
X-Google-Smtp-Source: AA0mqf6s8smqv/i1YqzLHJvMG3n2/14uOq3P4AI6rGj6IDCCm2/UQekcBQe8hsYeBXwlyliRSd0NHg==
X-Received: by 2002:a17:902:aa44:b0:189:fdf:a3d9 with SMTP id c4-20020a170902aa4400b001890fdfa3d9mr17652021plr.9.1669172754915;
        Tue, 22 Nov 2022 19:05:54 -0800 (PST)
Received: from localhost ([129.95.226.125])
        by smtp.gmail.com with ESMTPSA id t5-20020a6564c5000000b0046ae5cfc3d5sm9717692pgv.61.2022.11.22.19.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 19:05:54 -0800 (PST)
Date:   Tue, 22 Nov 2022 19:05:51 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Pengcheng Yang <yangpc@wangsu.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     Pengcheng Yang <yangpc@wangsu.com>
Message-ID: <637d8e0fb1afb_2b64920831@john.notmuch>
In-Reply-To: <1669082309-2546-5-git-send-email-yangpc@wangsu.com>
References: <1669082309-2546-1-git-send-email-yangpc@wangsu.com>
 <1669082309-2546-5-git-send-email-yangpc@wangsu.com>
Subject: RE: [PATCH RESEND bpf 4/4] selftests/bpf: Add ingress tests for txmsg
 with apply_bytes
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pengcheng Yang wrote:
> Currently, the ingress redirect is not covered in "txmsg test apply".
> 
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> ---

Thanks for adding extra test.

Acked-by: John Fastabend <john.fastabend@gmail.com>
