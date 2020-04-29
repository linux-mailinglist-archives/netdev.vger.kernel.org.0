Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556571BDD1C
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 15:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgD2NFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 09:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbgD2NFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 09:05:48 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7B0C03C1AD
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 06:05:48 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id h4so1945513wmb.4
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 06:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/8EkDb+jA4Y7UIYfY/fiveZv70ZqdtTBrbZAqolYyOc=;
        b=ZE68sFJf+zsFIvPysKOINPI+BjjiWzuI6EHne1ZHdZCHscaskebNWizOD/fqN9pwAS
         69t9UiqEiSNzLuIaqs1R8XDW5y1D+NfVypq8LA6I0MJKq+2wImlbH+DqzruiVipXGwyf
         MgWSP/AoFsSu0rH1mIxLyj7LTDeHuyWpEWNiRSxUsSCA1FVlOtRTYw3bRpgrFk8PhTPT
         BaGQQtJDxJWrsxgWU/Q/Uc70K2Eml5rFPuzF/x9YpJ0lTuMefihiCfs8Q9Wnz/z4GXhZ
         qQLcadKtaLRFbOBU68Z91dmcOmMLUI8uwkxOFDnnJsEpPqVm7DuwJZ9Xub8pxKKVvMFe
         ylzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/8EkDb+jA4Y7UIYfY/fiveZv70ZqdtTBrbZAqolYyOc=;
        b=rcJg+y68CS0L+9CZVDLk8AQIcDRV4LU5BhlsQ5mn0gkSZlZ9+ZTqBnabBZ+HVaxZLl
         6ePysNK+B6D2MPwJpeqERW6hdQ8NrU/1lbxqwb2QXhTQNJsTc+j4Mh3M2dYm9S4PjwEp
         DXXuKGF/2SRYhnKXzwmgQkLUv+1/vudq53kNGBOLaBToItPaLSLEu2fGktSvlh9E3Pmc
         Dbw/AYLSIeJY3RLN1itN6G2bXCbGEgnNnCIZxeEB1+fA2CuSQMMgiVnvY2PlmDUt+L2C
         6n2SOu0wWHoO/ilrENPrxcyODjGojgj5VmG4Ac/jQB3ffHqVXW5Yf8qfpxEnW/ppWStL
         0y5Q==
X-Gm-Message-State: AGi0PuZezH60axmiHt/XQKdSA9CZbOHghGPs7+meE6Ia94Ux/3Vuwsf5
        FXq77cwrNLfoWCHUVUoEpNT8TQ==
X-Google-Smtp-Source: APiQypIhAQ6bwmZ4+a+x4PrWnOxLWWWSjcCeelD9uJcXMtpNDreE560JEPOJsntb4w6q+NbB77miWg==
X-Received: by 2002:a1c:f306:: with SMTP id q6mr3139152wmq.169.1588165546975;
        Wed, 29 Apr 2020 06:05:46 -0700 (PDT)
Received: from localhost.localdomain ([194.53.185.38])
        by smtp.gmail.com with ESMTPSA id 74sm31568199wrk.30.2020.04.29.06.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 06:05:46 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>,
        Richard Palethorpe <rpalethorpe@suse.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: [PATCH bpf-next v2 0/3] tools: bpftool: probe features for unprivileged users
Date:   Wed, 29 Apr 2020 14:05:31 +0100
Message-Id: <20200429130534.11823-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set allows unprivileged users to probe available features with
bpftool. On Daniel's suggestion, the "unprivileged" keyword must be passed
on the command line to avoid accidentally dumping a subset of the features
supported by the system. When used by root, this keyword makes bpftool drop
the CAP_SYS_ADMIN capability and print the features available to
unprivileged users only.

The first patch makes a variable global in feature.c to avoid piping too
many booleans through the different functions. The second patch introduces
the unprivileged probing, adding a dependency to libcap. Then the third
patch makes this dependency optional, by restoring the initial behaviour
(root only can probe features) if the library is not available.

Cc: Richard Palethorpe <rpalethorpe@suse.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>

Quentin Monnet (3):
  tools: bpftool: for "feature probe" define "full_mode" bool as global
  tools: bpftool: allow unprivileged users to probe features
  tools: bpftool: make libcap dependency optional

 .../bpftool/Documentation/bpftool-feature.rst |  12 +-
 tools/bpf/bpftool/Makefile                    |  13 +-
 tools/bpf/bpftool/bash-completion/bpftool     |   2 +-
 tools/bpf/bpftool/feature.c                   | 141 +++++++++++++++---
 4 files changed, 142 insertions(+), 26 deletions(-)

-- 
2.20.1

