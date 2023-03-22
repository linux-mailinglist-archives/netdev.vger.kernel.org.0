Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A2E6C4090
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 03:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjCVCzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 22:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjCVCzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 22:55:41 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A07D51FB2
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 19:55:40 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id v48so11706841uad.6
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 19:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679453739;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pmPxYZGiJPiZNRp5uwXsLoq/VVVYbmKfehqhDP2+8mk=;
        b=tmxPBPDJ027exfIFTPiRwlM5v29gZGo9mSu3Sc1fEaywBnS7b0UlCSO8y7fV5VYv66
         pZwFdb1fIJ78fiFckXIsYSsf6ofCNMLFu1p61MzaMVHd7rkb0JSGnBSS1y1G4QiKcDPr
         FbAxJBnxasoVXoWNoRVCh5dLVzLyYERTgDdisj1ZRWNKY2jVFUIOARnRMqyGLjkRNI53
         G5+IlZPsakG7woRAR2h21ZpIPmaLkqtKZ1l9zRz31h5Gs5AxumLYwqPwYqRZVOwWXjm3
         Cp+3AO5/4ebVtvrA3tu37vNrOW/RWtWIWKCrkwAHvaCgveTbX1wrvZJPHJEDINdJ65eU
         198g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679453739;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pmPxYZGiJPiZNRp5uwXsLoq/VVVYbmKfehqhDP2+8mk=;
        b=02gKrlCGO8FmOlRy+uQKga7Jskqx6o8WrDKfLdyG3PYzFdee0sYCn4PMLT2g0Xohiw
         4rNUMjo2Ba1T41ZF5N2BfaDwDZ2lmvSC5MK7WJ1kB2vMA4Qfsyf+gI67w1E1BcwxbM1l
         FgpFqom+aq3Iy4DW3S+z2umrCDX8Q7BdSeTtQ5ZeDShLlIk7SlPk/aAPdE59Ac+aNzss
         BbbbPNzzdPMPyCNdQo3RmeCNe5kO8owUJpwgSnfYyOvyf/d0+WzXafpVJP3qRedHLiSf
         CTBE1cUPkJ/+c40ZVNB93/Tooz/fD9c/KaYth0ku8PHA9Wvvz8NnbZZ/FHYujqQWWM8G
         ID6w==
X-Gm-Message-State: AAQBX9fBMxpGrOo+pnMoLFVQRP45U7g+mZib8XTcOzo9lDKB5MERn6fa
        LWpd5RufxXg0AYM0Iu4bNIIjugZHFt8iEN027LSnVg==
X-Google-Smtp-Source: AK7set88KTLed2uOQKiUZQTXjNlhd7tIZ/C3aL/o4qrF3KJYeV9hU4bk7fS2WrV9zGbytrmRvjvA0gx0RpCt2voDi2E=
X-Received: by 2002:a05:6130:c84:b0:68b:b624:7b86 with SMTP id
 ch4-20020a0561300c8400b0068bb6247b86mr1994488uab.2.1679453739302; Tue, 21 Mar
 2023 19:55:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230321081202.2370275-1-lixiaoyan@google.com> <20230321081202.2370275-2-lixiaoyan@google.com>
In-Reply-To: <20230321081202.2370275-2-lixiaoyan@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 21 Mar 2023 19:55:27 -0700
Message-ID: <CANn89iKWCBOJEk5HVmC8xpnMxjyBYqNauEc0bBBrTBVutHRwYw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] selftests/net: Add SHA256 computation over
 data sent in tcp_mmap
To:     Coco Li <lixiaoyan@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Shakeel Butt <shakeelb@google.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 1:12=E2=80=AFAM Coco Li <lixiaoyan@google.com> wrot=
e:
>
> From: Xiaoyan Li <lixiaoyan@google.com>
>
> Add option to compute and send SHA256 over data sent (-i).
>
> This is to ensure the correctness of data received.
> Data is randomly populated from /dev/urandom.
>
> Tested:
> ./tcp_mmap -s -z -i
> ./tcp_mmap -z -H $ADDR -i
> SHA256 is correct
>
> ./tcp_mmap -s -i
> ./tcp_mmap -H $ADDR -i
> SHA256 is correct
>
> Signed-off-by: Coco Li <lixiaoyan@google.com>
>

Reviewed-by: Eric Dumazet <edumazet@google.com>
