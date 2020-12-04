Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A992C2CE56B
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 02:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgLDBym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 20:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbgLDBym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 20:54:42 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5A5C061A4F;
        Thu,  3 Dec 2020 17:54:01 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id t37so2565168pga.7;
        Thu, 03 Dec 2020 17:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=O1cheI3RQgNl858pR+KfM84bw+ujtHqyTQMeul/BZlk=;
        b=m3W4BmR1NndJZna6KNPAmdBblPonzQX1C/5sthtfF1btaR9DV5CdNROT2Q+2HDsa/f
         cfI+bPsqAJjmBIdj+x3XAsJWb2yOjLAZMvO8H35xluCS9jE/3gnfFFRChSfmyb66YLCT
         y0pydL1ZELHbUaR05A9DEE5gtiDJ9kTE3rxFthrYa4lZrDSKDfosjay+Z/b3tH+J6Vqp
         HqvztUfByYyRNXT/my8xfBfdf00PeO+CwAIGGVa6jmmvoODKf6QYFms0IIr6QSPc1ZHx
         Z4u1XwI2bplfJQ6naUp4z2CR7UUuYCVL1GOHrSrynIArQS1FnE3T9lDMED4gYq7zGvs0
         45Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O1cheI3RQgNl858pR+KfM84bw+ujtHqyTQMeul/BZlk=;
        b=kabU2T8Yu16Py/PkfWH7vlL479TAiSzmTB/gkuzwMvmiZZX5zaXkjk4unW3ToKjaKp
         /Z+ZVciy9y4mwVv9GzMHfiixEYvNJhKzwtf/WbQ9x6K9kf6mPhj8l6rrkOuJV7QEhR24
         Ipcs7YwMXB29Kt79XgjSAgHDKHHOTgaD4f1YLA156pbBX3tibRCc8n9npc8iqsg+WLod
         nDdYYU/FysZsD5WvT9ZxbhOSNhT2DLyHuZ2owDY7ENRhMdr1gO81MfKQX1wWe9NW/aPQ
         MjllJwvPNXQQqHoCZWQ8BuyimFVc70g2eU2TG203I7zTCSCiQpwBcLjZtjy0+iNm8MlB
         4gjQ==
X-Gm-Message-State: AOAM531TE4MqhiMAmYl2f3FXkl0X+6rw/eow9fYZd+0YiUSbGkKGlVAa
        udykq1M4FGmfXnpbfd7dxWs=
X-Google-Smtp-Source: ABdhPJwWPYfJEVhdwjckDuqURnZliJpe9qgly+274oP0+u8Uu1+8NCQ0+lDOVMVIcm5J9HO+F3e5cg==
X-Received: by 2002:a62:5253:0:b029:18a:b277:6be2 with SMTP id g80-20020a6252530000b029018ab2776be2mr1673786pfb.0.1607046841396;
        Thu, 03 Dec 2020 17:54:01 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:2ca])
        by smtp.gmail.com with ESMTPSA id x10sm2458023pfc.133.2020.12.03.17.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 17:54:00 -0800 (PST)
Date:   Thu, 3 Dec 2020 17:53:58 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
Subject: Re: [PATCH v6 bpf-next 10/14] bpf: allow to specify kernel module
 BTFs when attaching BPF programs
Message-ID: <20201204015358.sk5zl5l73zmcu7t2@ast-mbp>
References: <20201203204634.1325171-1-andrii@kernel.org>
 <20201203204634.1325171-11-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201203204634.1325171-11-andrii@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 12:46:30PM -0800, Andrii Nakryiko wrote:
> +	if (attr->attach_prog_fd) {
> +		dst_prog = bpf_prog_get(attr->attach_prog_fd);
> +		if (IS_ERR(dst_prog)) {
> +			dst_prog = NULL;
> +			attach_btf = btf_get_by_fd(attr->attach_btf_obj_fd);
> +			if (IS_ERR(attach_btf))
> +				return -EINVAL;
> +			if (!btf_is_kernel(attach_btf)) {
> +				btf_put(attach_btf);
> +				return -EINVAL;

Applied, but please consider follow up with different err code here.
I think we might support this case in the future.
Specifying prog's BTF as a base and attach_btf_id within it might make
user space simpler in some cases. prog's btf covers the whole elf file.
Where prog_fd is a specific prog. That narrow scope isn't really necessary.
So may be return ENOTSUPP here for now? With a hint that this might
work in the future?
