Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA563A714E
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 23:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234950AbhFNV2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 17:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234356AbhFNV2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 17:28:05 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01366C061574
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 14:25:49 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id m13-20020a17090b068db02901656cc93a75so434221pjz.3
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 14:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vDSMxsgZPMhZigWKQtEvrmLTP3r9HRflxl2RZITjhmQ=;
        b=eZBZyY8dPAtsg2d0KP5tZ77HNrxA4LLyNAq0LeGLlRil8WvOuDPEc4ptMkJXUIgfh3
         HWdgcdKMn6l5hxSpFK4XCTwoBDUO5/RgSEF9eham6y1rdHYZZWKlS0fW8GE/HhiXkWSL
         LywMbAcJ9Hp4dXHpVLTGhms+BmQj8sL7ri6Tu4LVJmeeCxI+7id+/m+m+BHLmU7GO+B3
         1Q1PKg0MzRZaeMLp9B5aKuL6wpZrRQDI+r7/jarYEYZQgE86PcJmRvFSvRdvnIOMRd2A
         kVd57Gy2H5futk0CHuU806DRK+VMEzkkmErl1K/ggJJ6prbKwjHHzcMtPOrZzCFTOgC7
         8plQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vDSMxsgZPMhZigWKQtEvrmLTP3r9HRflxl2RZITjhmQ=;
        b=Nh5bFUafTlK7dAvN9tpXlkU8swuUAjWPLaon9I5KuY5i85GQXYQkadg4WKpJILXxMB
         ebVHphGNQdDhhib9IDFZ6FuQ+bj2Jn8Dm+zISmfjtMT9DHv1fhhUobWOd2ZiBtAbMtor
         HgYZi24uSrxRfLRzjVcAxWiSwuRncT2BTQrvT4BYw9fu2ohh1QuRR+gLmuCdPLYv3G8I
         IwjAhnZacs1+YmPt+lbqa95H4vHuAjDeksBd1LCptYFBWGUtGxh4xfNvmlEv/Xjp2uPc
         dssL773Nc6Oj1k8ZBd1jKvVnjF/XzGT+e5HEi9HZXr2PNBk6l5xZQ/mZ96zc7qnr1vaS
         /vKw==
X-Gm-Message-State: AOAM531crtLWDkhWcp1C+3bEPCGrk9w51u9TQIozDnY/AFcS3PgBSc+r
        z9bDVInncSncdd21bRU/cY7OHz7N8HoFdtwR
X-Google-Smtp-Source: ABdhPJzks8W/msPFEvVEq5aKSqqeN7j7hv9y4kLHb6ZZ6Vl9aKrk2N8Gho38k6auF7d+bXkPMzveuQ==
X-Received: by 2002:a17:90b:fd4:: with SMTP id gd20mr1187646pjb.24.1623705948573;
        Mon, 14 Jun 2021 14:25:48 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id b123sm5479003pfg.62.2021.06.14.14.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 14:25:48 -0700 (PDT)
Date:   Mon, 14 Jun 2021 14:25:40 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     =?UTF-8?B?QXNiasO4cm4=?= Sloth =?UTF-8?B?VMO4bm5lc2Vu?= 
        <asbjorn@asbjorn.st>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH iproute2] tc: pedit: add decrement operation
Message-ID: <20210614142540.37eded6f@hermes.local>
In-Reply-To: <20210614203324.236756-1-asbjorn@asbjorn.st>
References: <20210614203324.236756-1-asbjorn@asbjorn.st>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Jun 2021 20:33:24 +0000
Asbj=C3=B8rn Sloth T=C3=B8nnesen         <asbjorn@asbjorn.st> wrote:

> @@ -422,16 +434,21 @@ int parse_cmd(int *argc_p, char ***argv_p, __u32 le=
n, int type, __u32 retain,
>  		goto done;
>  	}
> =20
>  	return -1;
> +


Please no unnecessary whitespace changes.

Also you are missing to print_pedit() to print the resulting change.
