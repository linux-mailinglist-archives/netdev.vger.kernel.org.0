Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01F91E5EB2
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 20:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfJZSmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 14:42:14 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44818 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbfJZSmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 14:42:14 -0400
Received: by mail-pl1-f194.google.com with SMTP id q16so2939818pll.11
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 11:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=+pUCwMw0bp6t9+incf6kf82pqWqXRfoOQ0MAJqkoLgI=;
        b=YjawuznejfBEfvkpQELvzCVAPNLadqBg+wsjEh7t38cig6hWMf8Cd+CfuRJhPZbhf2
         9R6zWQr7i1oc5p0sn6MOpNFze8FMpSfC/G8SdP5luQuoWJsOR4ONyLLklXQMi89V8Hjq
         Ybgqk3RZ53rb0Qjo9iN3zxDp/vXIm4Da1xBn4v1yNVdjP+uEoKtA0CeDNl87cVj2oTKq
         Ee65PRikFFSqCIfQFS0qi0D+ROZURWlPCcE7sfSyATEg6BzUEb6avHXE2aZmZWaDUmdg
         AMK4NA2SuF9TmJBtj/nPPWaU0nsgoo/6weJ7xuhob/cl3wZAxDT39ItUURySMYcIYH8m
         yQag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=+pUCwMw0bp6t9+incf6kf82pqWqXRfoOQ0MAJqkoLgI=;
        b=PX0YZNNFG/b534Y2ZG0KvltdsanLslWDTRQpIewU9KY4wV0vlulAxSWxUMamdutCUV
         kaemY8gH6i1+oRGdpzbOo8tlFs2V+BSw81YNra5FcNBB43bobHrLYiW0L6/m85ASLLt+
         eUnRdTUlTyy6wdLSYdM1Bmq8pODa6KxmVJCyclESxvZG9fOJWy7bNdgx5dxELwEWsnOJ
         JuExD6c9795vEWPJ8VR5lt+WLGQUckQ4JqL/iv7mSZw2R5zUH/4A4pMB5FqHha08TleN
         bCQCS/E2JKIqwRLMdnPf7WyT8Q6j4W8H32uxLgqAb+kdfI4cqCl4RmUKy5pzgSRXS1rY
         uLLQ==
X-Gm-Message-State: APjAAAXK9OirFppPe4vu045NFUSfDuNONqPyAFh0On/TGcqPy6jqi7KE
        l9CqFriRqXk12MiV2AsptHQToQ==
X-Google-Smtp-Source: APXvYqw1t8yDc5FGwNtOxkMmz1zB2cM5/0ECTYGbRXmQH3WJhzhJ8BMB8JTkmpnfKo5OG2nm4tOGwg==
X-Received: by 2002:a17:902:6944:: with SMTP id k4mr10922717plt.175.1572115332989;
        Sat, 26 Oct 2019 11:42:12 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id x10sm5722604pgl.53.2019.10.26.11.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Oct 2019 11:42:12 -0700 (PDT)
Date:   Sat, 26 Oct 2019 11:42:08 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH] bpftool: Allow to read btf as raw data
Message-ID: <20191026114208.49e35169@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191025200351.GA31835@krava>
References: <20191024133025.10691-1-jolsa@kernel.org>
        <20191025113901.5a7e121e@cakuba.hsd1.ca.comcast.net>
        <20191025200351.GA31835@krava>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Oct 2019 22:03:51 +0200, Jiri Olsa wrote:
> On Fri, Oct 25, 2019 at 11:39:01AM -0700, Jakub Kicinski wrote:
> > On Thu, 24 Oct 2019 15:30:25 +0200, Jiri Olsa wrote: =20
> > > The bpftool interface stays the same, but now it's possible
> > > to run it over BTF raw data, like:
> > >=20
> > >   $ bpftool btf dump file /sys/kernel/btf/vmlinux
> > >   [1] INT '(anon)' size=3D4 bits_offset=3D0 nr_bits=3D32 encoding=3D(=
none)
> > >   [2] INT 'long unsigned int' size=3D8 bits_offset=3D0 nr_bits=3D64 e=
ncoding=3D(none)
> > >   [3] CONST '(anon)' type_id=3D2
> > >=20
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org> =20
> >=20
> > Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com> =20
>=20
> [root@ibm-z-107 bpftool]# ./bpftool btf dump file /sys/kernel/btf/vmlinux=
  | head -3
> [1] INT '(anon)' size=3D4 bits_offset=3D0 nr_bits=3D32 encoding=3D(none)
> [2] INT 'long unsigned int' size=3D8 bits_offset=3D0 nr_bits=3D64 encodin=
g=3D(none)
> [3] CONST '(anon)' type_id=3D2
> [root@ibm-z-107 bpftool]# lscpu | grep Endian
> Byte Order:          Big Endian

Thanks for checking! I thought the on-disk format is fixed like the
ELF magic number. But if two bads make a right then all is good =E2=98=BA=
=EF=B8=8F
