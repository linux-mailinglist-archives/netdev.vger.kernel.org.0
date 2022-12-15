Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66FAA64D8C6
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 10:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiLOJl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 04:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiLOJlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 04:41:25 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23C4F56
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 01:41:24 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id l127so4828444oia.8
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 01:41:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8F7wtOoeFLzpfk0gfC277PaLARNAp8R02UbRAmi3iW0=;
        b=pp0AskGCk55IA/Bjy0ZEJD7Rpg9BGO3VInBVvbyW854PNy21FJ34zgvm0rZLgf2R+s
         HPC6YrDJE6JERGnEJEdDNmFVsTTwJo0lXB3azK4IT4con6hN1Nicw2HinN1mmZvD7HCA
         Xu3jvJwt/PTCa8AQLnni/AnxxnRGC8H1J4OWPwrOW2zWju0us2UHl3+Kt79/ovEYnPLu
         whfBOXj5TzHulOZ6MsntP9JTV9J8RBkhv7xCbiZWzll/oNdJ8ekf7jo3z78iz0M0gltE
         vT7F8wk2BSWuEy38cu/zcf8HU1m+Ar6V2BWjzboMewPT6FjEDhNNcsFZjG31RntTpD40
         khVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8F7wtOoeFLzpfk0gfC277PaLARNAp8R02UbRAmi3iW0=;
        b=c4BfigY16RzGVD78xkgmCCQF+oSeEgbp0YIu+yQXPTjLrIxBiIPPzb8CJvVwb6cKUS
         Uz/9bEj1rggxDCXfwsWkaYtYXqH9O7/wXUiMtoEtHvnBCEZRedaGFRoQS8rkoBtfDdaD
         GKSLvpXLx/CT8wLBB5aGCA9++mxc2I00Tm1y++9rXpG69jAi9jJTFzHHSLGG4y6hs+vA
         fVfO1DT981mSD8lPbYSiYrSSReg/EdwLcbiUXOAI4G5iTKBx4CYfxw/xTX89hvCEVb/a
         H/35bnU47887CtqWMXetlD/vrytY7fRi+9MldVFSpYzuQxQQG7vA0wBGdY9nJsiaRqmi
         g9lQ==
X-Gm-Message-State: ANoB5pnJZkA+XScqILNLyi5iVAg/gumB1ybBxHpTpKqztkBllujxgBUI
        B15lXgEVgSmxmbu9eNp+LdMbxIDPuPBfk7YEB7jwb8R418E=
X-Google-Smtp-Source: AA0mqf5VcZAvR05lFkKKsFDS6rq/0P+q5inCmgH43VHSmX4c1CBsR0Rr9Rm7s+iON009SS9AFwZ3ASrg+96oaPjnZyg=
X-Received: by 2002:a05:6808:140c:b0:35e:6ac9:fd0a with SMTP id
 w12-20020a056808140c00b0035e6ac9fd0amr242891oiv.245.1671097283992; Thu, 15
 Dec 2022 01:41:23 -0800 (PST)
MIME-Version: 1.0
From:   Amit Amit <amit.amit3979@gmail.com>
Date:   Thu, 15 Dec 2022 15:11:13 +0530
Message-ID: <CACyRiYqtZheD0E-S+mw15t5meKE1yGHV75JJdG+LwHf_ekAz4w@mail.gmail.com>
Subject: How to do per src ip bandwidth limit for 10K IPs
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

What is the best way to do bandwidth limit for 10K IPs?

One option is to create 10K filters and 10K classes.

But if for 5K, I want to limit to say 10Mbps and for remaining 5K I
want to limit to say 20Mbps ... isn't there a better option than
creating 10K filters and classes?

Can Cake help in this?
