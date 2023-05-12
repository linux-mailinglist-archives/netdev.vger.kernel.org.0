Return-Path: <netdev+bounces-2156-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67E257008E7
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:16:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E76C281A3F
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 13:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F7281DDF5;
	Fri, 12 May 2023 13:15:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B781DDFD
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:15:45 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EC114E51;
	Fri, 12 May 2023 06:15:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A0726229E6;
	Fri, 12 May 2023 13:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1683897292; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g3I2dAT8366+ROozP6HDSUhQz0IesKX8ZgohOghL0xU=;
	b=HMLHUxosusDuQL2j9yv1XWG1J3diNcF4W+naepqPV+3uHnZqDTsA0XNbsmlI+xI0xSBk1W
	lU0CEa60y+pWI1g3PLe6OkDtan+B1sjsk6Qh4LS3sglRYQ33pow/OI3CJZBcipsjtFV9rz
	bavjV1CN9EUz6p5rmCs8iklNM2ZYk5o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1683897292;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g3I2dAT8366+ROozP6HDSUhQz0IesKX8ZgohOghL0xU=;
	b=yVZMrjrrh4WMVLz8+6Hcyn23gGLFeRPU1vNjmyNl8+SYgYxE7JEX3wauwXTGx4HwPRdBqd
	gR+dobFmSCILXjCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7B91313466;
	Fri, 12 May 2023 13:14:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id BbMeHsw7XmT0NwAAMHmgww
	(envelope-from <jack@suse.cz>); Fri, 12 May 2023 13:14:52 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 17D85A0754; Fri, 12 May 2023 15:14:52 +0200 (CEST)
Date: Fri, 12 May 2023 15:14:52 +0200
From: Jan Kara <jack@suse.cz>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux DRI Development <dri-devel@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Networking <netdev@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Staging Drivers <linux-staging@lists.linux.dev>,
	Linux Watchdog Devices <linux-watchdog@vger.kernel.org>,
	Linux Kernel Actions <linux-actions@lists.infradead.org>,
	Diederik de Haas <didi.debian@cknow.org>,
	Kate Stewart <kstewart@linuxfoundation.org>,
	David Airlie <airlied@redhat.com>,
	Karsten Keil <isdn@linux-pingi.de>,
	Jay Vosburgh <j.vosburgh@gmail.com>,
	Andy Gospodarek <andy@greyhouse.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sam Creasey <sammy@sammy.net>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Daniel Mack <daniel@zonque.org>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Guenter Roeck <linux@roeck-us.net>, Jan Kara <jack@suse.com>,
	Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>,
	Manivannan Sadhasivam <mani@kernel.org>, Tom Rix <trix@redhat.com>,
	Simon Horman <simon.horman@corigine.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Pavel Machek <pavel@ucw.cz>, Minghao Chi <chi.minghao@zte.com.cn>,
	Kalle Valo <kvalo@kernel.org>,
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>, Deepak R Varma <drv@mailo.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Dan Carpenter <error27@gmail.com>, Archana <craechal@gmail.com>
Subject: Re: [PATCH 09/10] udf: Replace license notice with SPDX identifier
Message-ID: <20230512131452.q3sj77h54qqec355@quack3>
References: <20230511133406.78155-1-bagasdotme@gmail.com>
 <20230511133406.78155-10-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230511133406.78155-10-bagasdotme@gmail.com>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu 11-05-23 20:34:05, Bagas Sanjaya wrote:
> Except Kconfig and Makefile, all source files for UDF filesystem doesn't
> bear SPDX license identifier. Add appropriate license identifier while
> replacing boilerplates.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  fs/udf/balloc.c    |  6 +-----
>  fs/udf/dir.c       |  6 +-----
>  fs/udf/directory.c |  6 +-----
>  fs/udf/ecma_167.h  | 24 +-----------------------
>  fs/udf/file.c      |  6 +-----
>  fs/udf/ialloc.c    |  6 +-----
>  fs/udf/inode.c     |  6 +-----
>  fs/udf/lowlevel.c  |  6 +-----
>  fs/udf/misc.c      |  6 +-----
>  fs/udf/namei.c     |  6 +-----
>  fs/udf/osta_udf.h  | 24 +-----------------------
>  fs/udf/partition.c |  6 +-----
>  fs/udf/super.c     |  6 +-----
>  fs/udf/symlink.c   |  6 +-----
>  fs/udf/truncate.c  |  6 +-----
>  fs/udf/udftime.c   | 19 +------------------
>  fs/udf/unicode.c   |  6 +-----
>  17 files changed, 17 insertions(+), 134 deletions(-)
> 
> diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
> index 14b9db4c80f03f..a56eb6975d19c8 100644
> --- a/fs/udf/balloc.c
> +++ b/fs/udf/balloc.c
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * balloc.c
>   *
> @@ -5,11 +6,6 @@
>   *	Block allocation handling routines for the OSTA-UDF(tm) filesystem.
>   *
>   * COPYRIGHT
> - *	This file is distributed under the terms of the GNU General Public
> - *	License (GPL). Copies of the GPL can be obtained from:
> - *		ftp://prep.ai.mit.edu/pub/gnu/GPL
> - *	Each contributing author retains all rights to their own work.
> - *
>   *  (C) 1999-2001 Ben Fennema
>   *  (C) 1999 Stelias Computing Inc
>   *

So the explicit copyright speaks about GPL license but your SPDX identifier
speaks about GPLv2 only. I don't think we can change the license like this?
It applies also to some other UDF files you convert...

								Honza

> diff --git a/fs/udf/dir.c b/fs/udf/dir.c
> index 212393b12c2266..015e17382f975e 100644
> --- a/fs/udf/dir.c
> +++ b/fs/udf/dir.c
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * dir.c
>   *
> @@ -5,11 +6,6 @@
>   *  Directory handling routines for the OSTA-UDF(tm) filesystem.
>   *
>   * COPYRIGHT
> - *	This file is distributed under the terms of the GNU General Public
> - *	License (GPL). Copies of the GPL can be obtained from:
> - *		ftp://prep.ai.mit.edu/pub/gnu/GPL
> - *	Each contributing author retains all rights to their own work.
> - *
>   *  (C) 1998-2004 Ben Fennema
>   *
>   * HISTORY
> diff --git a/fs/udf/directory.c b/fs/udf/directory.c
> index 654536d2b60976..3b65d5dc70b008 100644
> --- a/fs/udf/directory.c
> +++ b/fs/udf/directory.c
> @@ -1,14 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * directory.c
>   *
>   * PURPOSE
>   *	Directory related functions
>   *
> - * COPYRIGHT
> - *	This file is distributed under the terms of the GNU General Public
> - *	License (GPL). Copies of the GPL can be obtained from:
> - *		ftp://prep.ai.mit.edu/pub/gnu/GPL
> - *	Each contributing author retains all rights to their own work.
>   */
>  
>  #include "udfdecl.h"
> diff --git a/fs/udf/ecma_167.h b/fs/udf/ecma_167.h
> index de17a97e866742..961e7bf5cb5c00 100644
> --- a/fs/udf/ecma_167.h
> +++ b/fs/udf/ecma_167.h
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: BSD-2-Clause OR GPL-1.0-only */
>  /*
>   * ecma_167.h
>   *
> @@ -8,29 +9,6 @@
>   * Copyright (c) 2017-2019  Pali Rohár <pali@kernel.org>
>   * All rights reserved.
>   *
> - * Redistribution and use in source and binary forms, with or without
> - * modification, are permitted provided that the following conditions
> - * are met:
> - * 1. Redistributions of source code must retain the above copyright
> - *    notice, this list of conditions, and the following disclaimer,
> - *    without modification.
> - * 2. The name of the author may not be used to endorse or promote products
> - *    derived from this software without specific prior written permission.
> - *
> - * Alternatively, this software may be distributed under the terms of the
> - * GNU Public License ("GPL").
> - *
> - * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
> - * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
> - * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
> - * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
> - * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
> - * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
> - * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
> - * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
> - * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
> - * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
> - * SUCH DAMAGE.
>   */
>  
>  /**
> diff --git a/fs/udf/file.c b/fs/udf/file.c
> index 8238f742377bab..a13622121a63c5 100644
> --- a/fs/udf/file.c
> +++ b/fs/udf/file.c
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * file.c
>   *
> @@ -5,11 +6,6 @@
>   *  File handling routines for the OSTA-UDF(tm) filesystem.
>   *
>   * COPYRIGHT
> - *  This file is distributed under the terms of the GNU General Public
> - *  License (GPL). Copies of the GPL can be obtained from:
> - *    ftp://prep.ai.mit.edu/pub/gnu/GPL
> - *  Each contributing author retains all rights to their own work.
> - *
>   *  (C) 1998-1999 Dave Boynton
>   *  (C) 1998-2004 Ben Fennema
>   *  (C) 1999-2000 Stelias Computing Inc
> diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
> index 8d50121778a57d..67a869cbf5987b 100644
> --- a/fs/udf/ialloc.c
> +++ b/fs/udf/ialloc.c
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * ialloc.c
>   *
> @@ -5,11 +6,6 @@
>   *	Inode allocation handling routines for the OSTA-UDF(tm) filesystem.
>   *
>   * COPYRIGHT
> - *	This file is distributed under the terms of the GNU General Public
> - *	License (GPL). Copies of the GPL can be obtained from:
> - *		ftp://prep.ai.mit.edu/pub/gnu/GPL
> - *	Each contributing author retains all rights to their own work.
> - *
>   *  (C) 1998-2001 Ben Fennema
>   *
>   * HISTORY
> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index 1e71e04ae8f6b9..7c1e083223211c 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * inode.c
>   *
> @@ -5,11 +6,6 @@
>   *  Inode handling routines for the OSTA-UDF(tm) filesystem.
>   *
>   * COPYRIGHT
> - *  This file is distributed under the terms of the GNU General Public
> - *  License (GPL). Copies of the GPL can be obtained from:
> - *    ftp://prep.ai.mit.edu/pub/gnu/GPL
> - *  Each contributing author retains all rights to their own work.
> - *
>   *  (C) 1998 Dave Boynton
>   *  (C) 1998-2004 Ben Fennema
>   *  (C) 1999-2000 Stelias Computing Inc
> diff --git a/fs/udf/lowlevel.c b/fs/udf/lowlevel.c
> index c87ed942d07653..28fc91f12da911 100644
> --- a/fs/udf/lowlevel.c
> +++ b/fs/udf/lowlevel.c
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * lowlevel.c
>   *
> @@ -5,11 +6,6 @@
>   *  Low Level Device Routines for the UDF filesystem
>   *
>   * COPYRIGHT
> - *	This file is distributed under the terms of the GNU General Public
> - *	License (GPL). Copies of the GPL can be obtained from:
> - *		ftp://prep.ai.mit.edu/pub/gnu/GPL
> - *	Each contributing author retains all rights to their own work.
> - *
>   *  (C) 1999-2001 Ben Fennema
>   *
>   * HISTORY
> diff --git a/fs/udf/misc.c b/fs/udf/misc.c
> index 3777468d06ce58..c0eaad4d0d86ff 100644
> --- a/fs/udf/misc.c
> +++ b/fs/udf/misc.c
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * misc.c
>   *
> @@ -5,11 +6,6 @@
>   *	Miscellaneous routines for the OSTA-UDF(tm) filesystem.
>   *
>   * COPYRIGHT
> - *	This file is distributed under the terms of the GNU General Public
> - *	License (GPL). Copies of the GPL can be obtained from:
> - *		ftp://prep.ai.mit.edu/pub/gnu/GPL
> - *	Each contributing author retains all rights to their own work.
> - *
>   *  (C) 1998 Dave Boynton
>   *  (C) 1998-2004 Ben Fennema
>   *  (C) 1999-2000 Stelias Computing Inc
> diff --git a/fs/udf/namei.c b/fs/udf/namei.c
> index fd20423d3ed24c..6d6cd24c7c2536 100644
> --- a/fs/udf/namei.c
> +++ b/fs/udf/namei.c
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * namei.c
>   *
> @@ -5,11 +6,6 @@
>   *      Inode name handling routines for the OSTA-UDF(tm) filesystem.
>   *
>   * COPYRIGHT
> - *      This file is distributed under the terms of the GNU General Public
> - *      License (GPL). Copies of the GPL can be obtained from:
> - *              ftp://prep.ai.mit.edu/pub/gnu/GPL
> - *      Each contributing author retains all rights to their own work.
> - *
>   *  (C) 1998-2004 Ben Fennema
>   *  (C) 1999-2000 Stelias Computing Inc
>   *
> diff --git a/fs/udf/osta_udf.h b/fs/udf/osta_udf.h
> index 157de0ec0cd530..85a5924873aeb5 100644
> --- a/fs/udf/osta_udf.h
> +++ b/fs/udf/osta_udf.h
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: BSD-2-Clause OR GPL-1.0-only */
>  /*
>   * osta_udf.h
>   *
> @@ -8,29 +9,6 @@
>   * Copyright (c) 2017-2019  Pali Rohár <pali@kernel.org>
>   * All rights reserved.
>   *
> - * Redistribution and use in source and binary forms, with or without
> - * modification, are permitted provided that the following conditions
> - * are met:
> - * 1. Redistributions of source code must retain the above copyright
> - *    notice, this list of conditions, and the following disclaimer,
> - *    without modification.
> - * 2. The name of the author may not be used to endorse or promote products
> - *    derived from this software without specific prior written permission.
> - *
> - * Alternatively, this software may be distributed under the terms of the
> - * GNU Public License ("GPL").
> - *
> - * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
> - * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
> - * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
> - * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
> - * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
> - * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
> - * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
> - * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
> - * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
> - * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
> - * SUCH DAMAGE.
>   */
>  
>  /**
> diff --git a/fs/udf/partition.c b/fs/udf/partition.c
> index 5bcfe78d5cabe9..7d78be28929906 100644
> --- a/fs/udf/partition.c
> +++ b/fs/udf/partition.c
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * partition.c
>   *
> @@ -5,11 +6,6 @@
>   *      Partition handling routines for the OSTA-UDF(tm) filesystem.
>   *
>   * COPYRIGHT
> - *      This file is distributed under the terms of the GNU General Public
> - *      License (GPL). Copies of the GPL can be obtained from:
> - *              ftp://prep.ai.mit.edu/pub/gnu/GPL
> - *      Each contributing author retains all rights to their own work.
> - *
>   *  (C) 1998-2001 Ben Fennema
>   *
>   * HISTORY
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index 6304e3c5c3d969..80bee18ec6e1f4 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * super.c
>   *
> @@ -15,11 +16,6 @@
>   *    https://www.iso.org/
>   *
>   * COPYRIGHT
> - *  This file is distributed under the terms of the GNU General Public
> - *  License (GPL). Copies of the GPL can be obtained from:
> - *    ftp://prep.ai.mit.edu/pub/gnu/GPL
> - *  Each contributing author retains all rights to their own work.
> - *
>   *  (C) 1998 Dave Boynton
>   *  (C) 1998-2004 Ben Fennema
>   *  (C) 2000 Stelias Computing Inc
> diff --git a/fs/udf/symlink.c b/fs/udf/symlink.c
> index a34c8c4e6d2109..0b91b2c92bddb8 100644
> --- a/fs/udf/symlink.c
> +++ b/fs/udf/symlink.c
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * symlink.c
>   *
> @@ -5,11 +6,6 @@
>   *	Symlink handling routines for the OSTA-UDF(tm) filesystem.
>   *
>   * COPYRIGHT
> - *	This file is distributed under the terms of the GNU General Public
> - *	License (GPL). Copies of the GPL can be obtained from:
> - *		ftp://prep.ai.mit.edu/pub/gnu/GPL
> - *	Each contributing author retains all rights to their own work.
> - *
>   *  (C) 1998-2001 Ben Fennema
>   *  (C) 1999 Stelias Computing Inc
>   *
> diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
> index 2e7ba234bab8b8..3fb6c2abb4dc34 100644
> --- a/fs/udf/truncate.c
> +++ b/fs/udf/truncate.c
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * truncate.c
>   *
> @@ -5,11 +6,6 @@
>   *	Truncate handling routines for the OSTA-UDF(tm) filesystem.
>   *
>   * COPYRIGHT
> - *	This file is distributed under the terms of the GNU General Public
> - *	License (GPL). Copies of the GPL can be obtained from:
> - *		ftp://prep.ai.mit.edu/pub/gnu/GPL
> - *	Each contributing author retains all rights to their own work.
> - *
>   *  (C) 1999-2004 Ben Fennema
>   *  (C) 1999 Stelias Computing Inc
>   *
> diff --git a/fs/udf/udftime.c b/fs/udf/udftime.c
> index fce4ad976c8c29..d525ea68725f1c 100644
> --- a/fs/udf/udftime.c
> +++ b/fs/udf/udftime.c
> @@ -1,21 +1,4 @@
> -/* Copyright (C) 1993, 1994, 1995, 1996, 1997 Free Software Foundation, Inc.
> -   This file is part of the GNU C Library.
> -   Contributed by Paul Eggert (eggert@twinsun.com).
> -
> -   The GNU C Library is free software; you can redistribute it and/or
> -   modify it under the terms of the GNU Library General Public License as
> -   published by the Free Software Foundation; either version 2 of the
> -   License, or (at your option) any later version.
> -
> -   The GNU C Library is distributed in the hope that it will be useful,
> -   but WITHOUT ANY WARRANTY; without even the implied warranty of
> -   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> -   Library General Public License for more details.
> -
> -   You should have received a copy of the GNU Library General Public
> -   License along with the GNU C Library; see the file COPYING.LIB.  If not,
> -   write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> -   Boston, MA 02111-1307, USA.  */
> +/* SPDX-License-Identifier: GPL-2.0-only */
>  
>  /*
>   * dgb 10/02/98: ripped this from glibc source to help convert timestamps
> diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
> index 622569007b530b..5d6b66e15fcded 100644
> --- a/fs/udf/unicode.c
> +++ b/fs/udf/unicode.c
> @@ -1,3 +1,4 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * unicode.c
>   *
> @@ -11,11 +12,6 @@
>   *	UTF-8 is explained in the IETF RFC XXXX.
>   *		ftp://ftp.internic.net/rfc/rfcxxxx.txt
>   *
> - * COPYRIGHT
> - *	This file is distributed under the terms of the GNU General Public
> - *	License (GPL). Copies of the GPL can be obtained from:
> - *		ftp://prep.ai.mit.edu/pub/gnu/GPL
> - *	Each contributing author retains all rights to their own work.
>   */
>  
>  #include "udfdecl.h"
> -- 
> An old man doll... just what I always wanted! - Clara
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

