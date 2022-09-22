Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9845E5779
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 02:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiIVAl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 20:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiIVAl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 20:41:28 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872CD6B64C;
        Wed, 21 Sep 2022 17:41:27 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id 13so17544284ejn.3;
        Wed, 21 Sep 2022 17:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=QgBu6l3SOQc9v277Gy+0Dwk3UC62V2zlMgK2CDkHwM4=;
        b=evWhPjTnvCy2qAfvOEtKk2l0OGVkU2o2R2FS/FnIRHwNJ4RJi55GI9l1rQhKnoHAJq
         yIPrmO0om61wS84O1OzQY4gvy3jTS7htSRrI7Blr3KMWS9++OI7wmcAXfwAWCIKf5Hd5
         +N3C++zPmH2J2GRnkbRar+gPoceIrNKgBV4oR6P26xre0P72Lnw9AlcOSgiox7pDQBUQ
         gLESxmJxKegpP73XCknbuQgBlgM/9b9BsUWjP5lDYFbLTwPpYfvec9MS5eQSB0xnap3F
         +vD6WdMc4b3xiliDjCfOY7avSuS3sxQX1CiPsZjAPAwoO7Mj5KRJyID4pMuc0yZ/Cysx
         IENw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=QgBu6l3SOQc9v277Gy+0Dwk3UC62V2zlMgK2CDkHwM4=;
        b=dC7LgsvdI3d0Hwh+Nb7DDyx/xqQ3pq33SqBLe1LpwSEWVQoOnJck32bW2Q1n6cY3/k
         MqyLpvns2XrrvmY520UrcuImXriGxOJmFLjvxLAP9/m5NKsLnnZ6a2rYo5cpfnsvKgWd
         QoAmMyf6bWTAkdfWFqmNm9fEKmzEMYeUx2qC2hYxqOxMFpd1CyyDT3l+3pdwgli6H667
         7yeZMvZfzDeYkTR41m9g0stvKKwk7L2z8AFxWh7C+KNGkCpstBiNysWdOrkGCduaGC20
         kPYR/+OnaMICKjWF/fLE63sxyiQPMg8Q2jpf58j3RFVmkw7zIg2iMnQlD3qaL+FoKnhc
         lRhg==
X-Gm-Message-State: ACrzQf3Gq2K03aKcjUAcDuRDKNSwDBFbRjjmYoQVBqa1ACWLpNjBzGmT
        sr9HYvGqAVzcmPaUlqNovAvmg6ZtXdnx7Vp/L3k=
X-Google-Smtp-Source: AMsMyM5fEHkkqOS+igET9j4G33WfnWE/gcXQj0zep94rSz1jU3juUCEoiKzsEe45QEMXXXoP+aemleY+1utr67FCMhg=
X-Received: by 2002:a17:907:96a3:b0:780:633:2304 with SMTP id
 hd35-20020a17090796a300b0078006332304mr694171ejc.115.1663807285946; Wed, 21
 Sep 2022 17:41:25 -0700 (PDT)
MIME-Version: 1.0
References: <1663555725-17016-1-git-send-email-wangyufen@huawei.com>
In-Reply-To: <1663555725-17016-1-git-send-email-wangyufen@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 21 Sep 2022 17:41:14 -0700
Message-ID: <CAEf4BzbacgBeBrJcutGrpMceD2ipYyvRgrwyKdATN0K39adg5Q@mail.gmail.com>
Subject: Re: [bpf-next v3 1/2] libbpf: Add pathname_concat() helper
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, paul.walmsley@sifive.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, trix@redhat.com, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 18, 2022 at 7:28 PM Wang Yufen <wangyufen@huawei.com> wrote:
>
> Move snprintf and len check to common helper pathname_concat() to make the
> code simpler.
>
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>  tools/lib/bpf/libbpf.c | 76 +++++++++++++++++++-------------------------------
>  1 file changed, 29 insertions(+), 47 deletions(-)
>

[...]

> @@ -8009,14 +8012,9 @@ int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
>                 char buf[PATH_MAX];
>
>                 if (path) {
> -                       int len;
> -
> -                       len = snprintf(buf, PATH_MAX, "%s/%s", path,
> -                                      bpf_map__name(map));
> -                       if (len < 0)
> -                               return libbpf_err(-EINVAL);
> -                       else if (len >= PATH_MAX)
> -                               return libbpf_err(-ENAMETOOLONG);
> +                       err = pathname_concat(path, bpf_map__name(map), buf, PATH_MAX);
> +                       if (err)
> +                               return err;

also keep libbpf_err() as well, it sets errno properly

>                         sanitize_pin_path(buf);
>                         pin_path = buf;
>                 } else if (!map->pin_path) {
> @@ -8034,6 +8032,7 @@ int bpf_object__unpin_maps(struct bpf_object *obj, const char *path)
>  int bpf_object__pin_programs(struct bpf_object *obj, const char *path)
>  {
>         struct bpf_program *prog;
> +       char buf[PATH_MAX];
>         int err;
>
>         if (!obj)

[...]
