Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F2D4AD824
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 13:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245010AbiBHMGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 07:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233096AbiBHMGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 07:06:55 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9E7C03FECA
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 04:06:54 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id k25so51182708ejp.5
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 04:06:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FXGkFFi0ny4hdmpTVKgt323AqjwINIUXguF90H/Ze4k=;
        b=7dCLKTmIfVeuBY6hV3wNkhhfl2hB4NZOpQQ/Ea7wwPbUmCONsfC2/BEE6HOkeCYe1Y
         QVhup2jMyaCyprbqm/3qQhBxnoyGuBaguI4JCG6TxOTio/5D1ZItzu4+Q1z1787WCTyh
         WAyRqdfeeoF32YdIV8n5tLW59RcPXxJIiAvWQ6Mgi9kM4HfH/5A70xndfBdNyqwfBr0F
         nwU1S/UfmfzOnVAtrD1UfcteoaDg5PxlxyeuZlSM+2AbvX+Awd1j7TnI4XTpBZu/iWSF
         gDaNGiIq80GkWXGju4mLLeTxU19scstd2lBhzl4wlshwau7dmcmWuCRW36bVJyhbPNV1
         4Kjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FXGkFFi0ny4hdmpTVKgt323AqjwINIUXguF90H/Ze4k=;
        b=mUjoD/+pgcbQWyJYklMHCwZKea4Ujf+Mg2e4U5HgiB3icDCe3dyNeFbYDnA8qn/PzS
         dnSiXzlRM6w4xwC9xL9TKMoZTC6B9qLnZJK6tVUuVmgf1Jt2ZiMalP1yF6fR9e+GmEUW
         KLaSlwBFp5kyLxW/e6WKp0izxpWvz/+z963H0onmSjd1dRRznM6DH3jIBeV1wacNjbgS
         Xt5zLz8I564VChS31OjA3/m9VqjxHZBx7XfRbgIaPrRoCATNF03FNCb+ctqXOddKS9LQ
         JALYQXAOlT6s7f0i2PI5hgy/7iqkSzCVgzUzQHWA0GUQvtMhPFQk5tjg7vk/zUvUaWJ5
         +sfw==
X-Gm-Message-State: AOAM5327Lr8scJXpVSdn7ASrDLiJw8I+XTR0qhlI9HIYa/6pAC9ePkrF
        EKr88fsiAmE8VwBE0VOIbotA0g==
X-Google-Smtp-Source: ABdhPJxx+Nwnocmt/Vs4ZgvqNBdOCCPknsuiToOaU1xcProFVsXYUrbzCrXZDH5vABwLCI2kBb15gA==
X-Received: by 2002:a17:906:faec:: with SMTP id lu44mr3349687ejb.216.1644322012677;
        Tue, 08 Feb 2022 04:06:52 -0800 (PST)
Received: from localhost.localdomain ([149.86.77.242])
        by smtp.gmail.com with ESMTPSA id m17sm5567351edr.62.2022.02.08.04.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 04:06:51 -0800 (PST)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 0/3] bpftool: Switch to new versioning scheme (align on libbpf's)
Date:   Tue,  8 Feb 2022 12:06:45 +0000
Message-Id: <20220208120648.49169-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, this set aims at updating the way bpftool versions are numbered.
Instead of copying the version from the kernel (given that the sources for
the kernel and bpftool are shipped together), align it on libbpf's version
number, with a fixed offset (6) to avoid going backwards. Please refer to
the description of the third commit for details on the motivations.

The patchset also adds the number of the version of libbpf that was used to
compile to the output of "bpftool version". Bpftool makes such a heavy
usage of libbpf that it makes sense to indicate what version was used to
build it.

v2:
- Align on libbpf's version number instead of creating an independent
  versioning scheme.
- Use libbpf_version_string() to retrieve and display libbpf's version.
- Re-order patches (1 <-> 2).

Quentin Monnet (3):
  bpftool: Add libbpf's version number to "bpftool version" output
  libbpf: Add "libbpversion" make target to print version
  bpftool: Update versioning scheme, align on libbpf's version number

 .../bpf/bpftool/Documentation/common_options.rst  | 13 +++++++------
 tools/bpf/bpftool/Makefile                        | 15 +++++++++------
 tools/bpf/bpftool/main.c                          |  4 ++++
 tools/lib/bpf/Makefile                            |  3 +++
 4 files changed, 23 insertions(+), 12 deletions(-)

-- 
2.32.0

