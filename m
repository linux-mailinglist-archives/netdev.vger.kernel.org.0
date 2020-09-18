Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6522703B5
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 20:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgIRSG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 14:06:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726118AbgIRSG6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 14:06:58 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BCA321741;
        Fri, 18 Sep 2020 18:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600452417;
        bh=11zzBTt+zJr1XN2e3FnZDCJY23qoqQtx3dyPT9fdqgU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SUx6YZW8PY2oISsxk+8BFbA9qE8GSbrXfngZtbiY7t+mSNZU9jgGvvM7nVRWLP6wM
         PZ0YMwf8YUiexftTw5VrDZbdwAjw/c2dRv31vR4592wtxj3E2bE/MJwwC/vPw/YwTy
         tWkZ8n64NqF1YE030kB6RwL71azn+9SWgF6sy3XU=
Message-ID: <369798037f17899dbb775915bfafc363880fedbb.camel@kernel.org>
Subject: Re: [PATCH v3,net-next,0/4] Add Support for Marvell OcteonTX2
 Cryptographic
From:   Saeed Mahameed <saeed@kernel.org>
To:     Srujana Challa <schalla@marvell.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        kuba@kernel.org, sgoutham@marvell.com, gakula@marvell.com,
        sbhatta@marvell.com, schandran@marvell.com, pathreya@marvell.com
Date:   Fri, 18 Sep 2020 11:06:55 -0700
In-Reply-To: <20200917132835.28325-1-schalla@marvell.com>
References: <20200917132835.28325-1-schalla@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-09-17 at 18:58 +0530, Srujana Challa wrote:
> The following series adds support for Marvell Cryptographic
> Acceleration
> Unit(CPT) on OcteonTX2 CN96XX SoC.
> This series is tested with CRYPTO_EXTRA_TESTS enabled and
> CRYPTO_DISABLE_TESTS disabled.
> 

I am with Jakub on this one, 10K LOC require more explanation in the
cover-letter.
e.g. some background, high level design, device components being
added/changed.  Basically, what should we expect code-wise before we
jump into 10K LOC review..

> Changes since v2:
>  * Fixed C=1 warnings.
>  * Added code to exit CPT VF driver gracefully.
>  * Moved OcteonTx2 asm code to a header file under include/linux/soc/
> 
> Changes since v1:
>  * Moved Makefile changes from patch4 to patch2 and patch3.
> 
> Srujana Challa (3):
>   octeontx2-pf: move asm code to include/linux/soc
>   octeontx2-af: add support to manage the CPT unit
>   drivers: crypto: add support for OCTEONTX2 CPT engine
>   drivers: crypto: add the Virtual Function driver for OcteonTX2 CPT
> 
>  MAINTAINERS                                   |    2 +
>  drivers/crypto/marvell/Kconfig                |   17 +
>  drivers/crypto/marvell/Makefile               |    1 +
>  drivers/crypto/marvell/octeontx2/Makefile     |   10 +
>  .../marvell/octeontx2/otx2_cpt_common.h       |   53 +
>  .../marvell/octeontx2/otx2_cpt_hw_types.h     |  467 ++++
>  .../marvell/octeontx2/otx2_cpt_mbox_common.c  |  286 +++
>  .../marvell/octeontx2/otx2_cpt_mbox_common.h  |  100 +
>  .../marvell/octeontx2/otx2_cpt_reqmgr.h       |  197 ++
>  drivers/crypto/marvell/octeontx2/otx2_cptlf.h |  356 +++
>  .../marvell/octeontx2/otx2_cptlf_main.c       |  967 ++++++++
>  drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   79 +
>  .../marvell/octeontx2/otx2_cptpf_main.c       |  598 +++++
>  .../marvell/octeontx2/otx2_cptpf_mbox.c       |  694 ++++++
>  .../marvell/octeontx2/otx2_cptpf_ucode.c      | 2173
> +++++++++++++++++
>  .../marvell/octeontx2/otx2_cptpf_ucode.h      |  180 ++
>  drivers/crypto/marvell/octeontx2/otx2_cptvf.h |   29 +
>  .../marvell/octeontx2/otx2_cptvf_algs.c       | 1698 +++++++++++++
>  .../marvell/octeontx2/otx2_cptvf_algs.h       |  172 ++
>  .../marvell/octeontx2/otx2_cptvf_main.c       |  229 ++
>  .../marvell/octeontx2/otx2_cptvf_mbox.c       |  189 ++
>  .../marvell/octeontx2/otx2_cptvf_reqmgr.c     |  540 ++++
>  .../ethernet/marvell/octeontx2/af/Makefile    |    3 +-
>  .../net/ethernet/marvell/octeontx2/af/mbox.h  |   85 +
>  .../net/ethernet/marvell/octeontx2/af/rvu.c   |    2 +-
>  .../net/ethernet/marvell/octeontx2/af/rvu.h   |    7 +
>  .../ethernet/marvell/octeontx2/af/rvu_cpt.c   |  343 +++
>  .../marvell/octeontx2/af/rvu_debugfs.c        |  342 +++
>  .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   76 +
>  .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   65 +-
>  .../marvell/octeontx2/nic/otx2_common.h       |   13 +-
>  include/linux/soc/marvell/octeontx2/asm.h     |   29 +
>  32 files changed, 9982 insertions(+), 20 deletions(-)
>  create mode 100644 drivers/crypto/marvell/octeontx2/Makefile
>  create mode 100644
> drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
>  create mode 100644
> drivers/crypto/marvell/octeontx2/otx2_cpt_hw_types.h
>  create mode 100644
> drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
>  create mode 100644
> drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.h
>  create mode 100644
> drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptlf.h
>  create mode 100644
> drivers/crypto/marvell/octeontx2/otx2_cptlf_main.c
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptpf.h
>  create mode 100644
> drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
>  create mode 100644
> drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
>  create mode 100644
> drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
>  create mode 100644
> drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.h
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf.h
>  create mode 100644
> drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.c
>  create mode 100644
> drivers/crypto/marvell/octeontx2/otx2_cptvf_algs.h
>  create mode 100644
> drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
>  create mode 100644
> drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
>  create mode 100644
> drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
>  create mode 100644
> drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
>  create mode 100644 include/linux/soc/marvell/octeontx2/asm.h
> 

