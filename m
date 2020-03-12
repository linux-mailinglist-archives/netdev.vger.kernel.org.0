Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 674D11838F4
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgCLSq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:46:27 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34769 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726965AbgCLSq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 14:46:26 -0400
Received: by mail-wr1-f67.google.com with SMTP id z15so8866375wrl.1
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 11:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wHahHzzB1M6+8JJ7CuCuHPOxvXEu0XndSLd5n2mjxiM=;
        b=uqjUIowAJXYCGXsxX5gUJnJiRkx/uj06Ivjh0nNzP1LvWSfSIGo2eoitaeNL0Do24/
         FjwVtH8tK9gUQZPpa/4Zr93Dce1kADQ9ucQzHfJbHVRd6cc1Np09x4cANumhWSEAnaKK
         XCzi5rHy3qqEW9hUnqnzeyhrI5yp7KL9xk/XvsF5DjXL8heF53tVdhD/2LWAOlkxcg33
         2UAKS5HMmdRp7mZ+4cwSrn9osRNIr4nEyO9stqFaacOJuIK6V0dZl/j7IgClemtJBihU
         dHwwS8mdhOH7oKgGMpwKewflEHgDzv70XtZVGltwYxdek9pS6Alsu7zTO+QNmUraFilf
         11Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wHahHzzB1M6+8JJ7CuCuHPOxvXEu0XndSLd5n2mjxiM=;
        b=LxiL0+OEjTlF21LAihwznzOGWIhDNo/oyJpXMKxg+i6hl5nGjJmnpvNJrKQwoR6jG0
         KFRWIfOW1yOMC1EiWdNNN1vPpasFq2PlsKUL/nk/B1Xc7dmrU96qLqtIpZoZXqGwPegj
         QNdr+EqOTD2NA5bY45fqQjwPjQ/ZHXbUQxVjfRCvdLgfa9HdYiiK3i4ekkyGU9VIG+wg
         1Ilvj1D2I00Rn5zT9+e+KhdD/KU240/kltSvUGSIw1pEjSDty7UQxe5tQMcWWGcBRguj
         G2wWDLaUP/9KJfxy1S07KN7QiBvdGnbMKMfT4Spm92WKsslpGOcU+Uo2T+kmAJLtQFQW
         VSrg==
X-Gm-Message-State: ANhLgQ2IWw6T6VMu5SugkrdtxIQmIyFhemnutl06iFsj7c61oLMP1LOF
        vr/AiUwdyDfkNxg2VVaKU4Spvg==
X-Google-Smtp-Source: ADFU+vueKDG1/hYIOSadvAMIOn9AlXAxKy54UOlSYRwnLgl1RLlutSjMQkTzwPTaRprEU2MndYPEvw==
X-Received: by 2002:a5d:4a10:: with SMTP id m16mr11852192wrq.333.1584038784201;
        Thu, 12 Mar 2020 11:46:24 -0700 (PDT)
Received: from localhost.localdomain ([194.35.118.177])
        by smtp.gmail.com with ESMTPSA id b12sm50019665wro.66.2020.03.12.11.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 11:46:23 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 0/2] tools: bpftool: fix object pinning and bash
Date:   Thu, 12 Mar 2020 18:46:06 +0000
Message-Id: <20200312184608.12050-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch of this series improves user experience by allowing to pass
all kinds of handles for programs and maps (id, tag, name, pinned path)
instead of simply ids when pinning them with "bpftool (prog|map) pin".

The second patch improves or fix bash completion, including for object
pinning.

v2: Restore close() on file descriptor after pinning the object.

Quentin Monnet (2):
  tools: bpftool: allow all prog/map handles for pinning objects
  tools: bpftool: fix minor bash completion mistakes

 tools/bpf/bpftool/bash-completion/bpftool | 29 ++++++++++++++------
 tools/bpf/bpftool/common.c                | 33 +++--------------------
 tools/bpf/bpftool/main.h                  |  2 +-
 tools/bpf/bpftool/map.c                   |  2 +-
 tools/bpf/bpftool/prog.c                  |  2 +-
 5 files changed, 28 insertions(+), 40 deletions(-)

-- 
2.20.1

