Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C533BCF0B3
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 03:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729705AbfJHB7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 21:59:45 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40931 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbfJHB7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 21:59:44 -0400
Received: by mail-pf1-f195.google.com with SMTP id x127so9820668pfb.7
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 18:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=SxiZiPgSsJ2mifRWA9TgfeZi4oLuQHvNJ4v5K9ZfYEA=;
        b=O64YRFK+2b/xBzxfkUVKnFYAGUgniDR5D1vYDP9EmbnfNLh9LSfe4bttoIBiB59Xir
         Iy0WwUpnwDDNg9E9gKFkyOc8XTVfsWG2yzCjZmujG0gQaIigA2T9+fY/BvQR1qLocSb0
         vWvcNmR+CaxLTUc6XirnsGY/sDruyl65GTgFGQu/8j3vSpwlMDP0I4NJWdUcQOLsNxW5
         MH8T3hwivHUfikymd6geaH3DckTEZLiQ5Sgg9cRqo+iuevwFWTszTIl79x6G757ZOK6T
         cb9akjcEoxJW+Ea6xFY0SncYcodpzPwmSnQYqrXvLGgK7amrtBmnqE8nEjbz4eszB9S2
         1Q1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=SxiZiPgSsJ2mifRWA9TgfeZi4oLuQHvNJ4v5K9ZfYEA=;
        b=tA5r+q75eoD2qojNlKH8ALNfOwLdCiZROc7PSKv5U7LdcDlwiy4uo39NAEAEpcS1UV
         Gy4maRt3tb4cBLV21DSHKJFCemkQ4BxJnfUdeW4ZhONb2t4H4Yav7q+Q3quVEUnzoC0H
         3A/sS4/RBSqHxnv4aM/S//iBMbIrvMhTBsLYKrMVrpfGEYCaxJ+RgoP3oD1tPbpED354
         28EehqNkbg8kwrFITM+o/mPZgtq8UeRBokTsw6xGx0zEiPF0+xFWLPH1TTFi/M6t4VMG
         RPRzM3j9EfcQOcUsYZ5hGsuWu8H6E7RuwlUfL5LSYo0jvmZJnjGQM+bau35q08AYbWRx
         sYOw==
X-Gm-Message-State: APjAAAXiJscBKleeLGPhZV6QhFWToXmc/STSoQ+99oLQ4C/b3vqUcW24
        jXaywx/rF8vE/EWOieE8mh4Ap6QJ+JI=
X-Google-Smtp-Source: APXvYqymAIpCz1W6kwdBCYc8waIiyAokKTujYW8MvhAvn4ruPXB1ErEbtfVyI9RXmHce9L0M4/cukA==
X-Received: by 2002:aa7:95a7:: with SMTP id a7mr36720517pfk.158.1570499982577;
        Mon, 07 Oct 2019 18:59:42 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id b5sm16468593pfp.38.2019.10.07.18.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 18:59:42 -0700 (PDT)
Date:   Mon, 7 Oct 2019 18:59:32 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <sdf@google.com>,
        <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next] bpftool: fix bpftool build by switching to
 bpf_object__open_file()
Message-ID: <20191007185932.24d00391@cakuba.netronome.com>
In-Reply-To: <20191007225604.2006146-1-andriin@fb.com>
References: <20191007225604.2006146-1-andriin@fb.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Oct 2019 15:56:04 -0700, Andrii Nakryiko wrote:
> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> index 43fdbbfe41bb..27da96a797ab 100644
> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c
> @@ -1092,9 +1092,7 @@ static int do_run(int argc, char **argv)
>  static int load_with_options(int argc, char **argv, bool first_prog_only)
>  {
>  	struct bpf_object_load_attr load_attr = { 0 };
> -	struct bpf_object_open_attr open_attr = {
> -		.prog_type = BPF_PROG_TYPE_UNSPEC,
> -	};
> +	enum bpf_prog_type common_prog_type = BPF_PROG_TYPE_UNSPEC;
>  	enum bpf_attach_type expected_attach_type;
>  	struct map_replace *map_replace = NULL;
>  	struct bpf_program *prog = NULL, *pos;

Please maintain reverse xmas tree..
