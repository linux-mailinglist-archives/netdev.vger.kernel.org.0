Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67BB6A21B2
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjBXSof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBXSoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:44:34 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD862515E7
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:44:33 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id x17so3873991qkp.12
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:44:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=z/v5y8HucApiwArrniNSdAAxFsXvoFPe9o+Sj0andQA=;
        b=oV/xlHtIcbO2ewCH9LhB0fzAxAAteTaZ4Rt5zGk5dRL/orxLDYd685kPA8cxapRZcq
         VEGfhngvYPmm1faxqyo0tgigzJB3DQBQTVLBuM625aeLb0YIRHk7wcpE9VBv/YRBUjb4
         Tb5jCg6/084GXzsEVXKv8sR4NcosDvWWfq4aZmVXgsf+2wOVlWfjwRGG9VHFEqwnvLRQ
         G/lbsqoZbV/FxX5pF/6UKd8434okXbYcf7bjPgBMnSAfNTispYoiAywq3orZmAFE4xjt
         l/F1uQx29cJ+aTKkvQuX7+NAuop27blZDxgSCTYszkEb5qRH8+GUoUZRQT3j1vZnuJZ7
         uiBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z/v5y8HucApiwArrniNSdAAxFsXvoFPe9o+Sj0andQA=;
        b=kgc/SHo6zGhO/VSvhrhOilbDXDNrKlw0ERe6xBeGFaSk6Ol+IrwhC0+etUUm2Q9CzU
         czJVdaDFWusRKcnUpQ9oRIyq/HqMXWNpqqdzXiOUsqBKDMwxFHsSgUmDbmfro/la3r8e
         rnNMZVDP5CGdg7FMoR/4xNbEgoC6THWxb7qonmyJE2ybqmuBZ67TfxTrLt42h/Imsa0M
         rYMBJgRzC8rZ+9GeG9IRecdrT2j3lkKP6e/7ev6oEq8y+wuW6dmU/7fHCM1uIz3e3+AG
         mjodIQ8dmjHP9K/0VqTsl5sbJg4n9y0y8U4wbB+cO8rzFB8WNLTPOa0bm8Fq87SR1cGe
         nkYQ==
X-Gm-Message-State: AO0yUKXPN2T8YPEXoyyhVu2PsoMcUzSwDXWQ0hw06RGhzuuZLjH3ApGx
        UFVsGx7TW/CROrGQqCwJF2mT9z6d+fbK9HXD8nmakEbT/fs=
X-Google-Smtp-Source: AK7set9vr8skB/FD7/9EsqsxDZd4dMkSNAP3Q7ttmGAOsfjqwassp1x+/1ewGO5O6YkJG+dgiHBBTbQyjAnl5PtSW5I=
X-Received: by 2002:a05:620a:831a:b0:742:3e52:f855 with SMTP id
 pa26-20020a05620a831a00b007423e52f855mr2043010qkn.2.1677264272610; Fri, 24
 Feb 2023 10:44:32 -0800 (PST)
MIME-Version: 1.0
From:   Satyavani Namala <vani.namala@gmail.com>
Date:   Sat, 25 Feb 2023 00:14:21 +0530
Message-ID: <CAAycz1m+AszZCS-1eaKZiAAXRUVSEE4a_Z3X3j4Rjyvmce4zvA@mail.gmail.com>
Subject: Issue with ipv6 icmp reply after dnat over ipsec
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are facing an issue while testing ICMP v6 (NAT) with ipsec tunnel,
where ping was not working , as policy is not matching (returning with
LINUX_MIB_XFRMINNOPOLS).

When we investigated and compared with IPv4 , it was found that,
nf_reset is happening before xfrm6_policy_check in case of IPV6
compared to IPV4 in which nf_reset is done after xfrm4_policy_check.

Due to nf_reset, skb->_nfct is  NULL and __xfrm_policy_check is returning e=
rror.

Can we know if there is any fix in this area, and why it=E2=80=99s differen=
t from IPv4.
