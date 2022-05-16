Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB89527C93
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 05:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239826AbiEPDxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 23:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239393AbiEPDxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 23:53:48 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9940FD17;
        Sun, 15 May 2022 20:53:47 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id q4so13264925plr.11;
        Sun, 15 May 2022 20:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6UBHO1EGmJn+4vtFUEVZC6X5sivEbREsXHE7onCtc80=;
        b=gH9jilkJ2sX6gauODJgmNbh3oQO9EsapYqYQE59IEET48ygXfvNalBkpfkWiy35Mrk
         SF2ZI/1bKa8dOdDGc4h4oT+92196qDNcw9PpGRgNZdO9kIrooUd+cV/jy+l2IeVYO4Sb
         Fo0Q7Msi+XjGGkzhLtGpKb2kZb1RDXDAPUbpCKs4+1BY3WWJ/lzvYsTFA8FZ5bOBt+T+
         hns56m8O15cs1C0viCr8+wRBYWkzsAjF1GEGB8zgjGGZmPL2HD0jCZSzPdmilaLqCMZe
         9T0vQloBXv80E5nsL8kE+osa5pZF1OFSc5LLpsCuoAhBXv7H+SX4+9jWUMhFrt/CkYAM
         CXcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6UBHO1EGmJn+4vtFUEVZC6X5sivEbREsXHE7onCtc80=;
        b=sX94srpxJQxy/7PO6jJ/GcCNxhxnpzrnNvFRQ+jqApmPmJNGZZU5GiF0NrpbOsxtNy
         GFJgtM957CHx8ZeiecoR2iDSItvIYe1Yq+yDgaX1xoZICLVARIGx+jNFCaPTRLOKjEY2
         hQeR8x5Zj0suONBBycvDv3Ml7Kn6Lth2wpYdromXQp/uctfy2jt4B0VIajiAIvQ630l/
         9wrzcVXBj3xCAF48dBhZVNg7Pw6dFvcDfE74q8twMBQR2+QPty+6OI9q+fp0+hbm+r5T
         pi5TzQB7TVAUAw7ajSDGQ1ZvBEnpt5K7BJbP0HRt3Kp5DBvMqRk1zZAyOgF2SpDi8wRs
         W2+w==
X-Gm-Message-State: AOAM533+coix8CZLatIxhllcvOm9ZxFN3YMMKVwHCoA1XZp+5B8Veii1
        kKJL41UoKSe6IQ1p56/fawA=
X-Google-Smtp-Source: ABdhPJwUnnkcxhdn/ys0LTUsohC/zRgCScfwcmMv+PATWs6ztosqvOf+Y+4a9LnE7xIiGoSjGckq3w==
X-Received: by 2002:a17:90b:1c0e:b0:1dc:45b6:6392 with SMTP id oc14-20020a17090b1c0e00b001dc45b66392mr17068153pjb.236.1652673227262;
        Sun, 15 May 2022 20:53:47 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h14-20020a170902680e00b0015e8d4eb2afsm3023159plk.249.2022.05.15.20.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 May 2022 20:53:46 -0700 (PDT)
Date:   Mon, 16 May 2022 11:53:39 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH net 1/2] selftests/bpf: Fix build error with ima_setup.sh
Message-ID: <YoHKw/at89Wp19F/@Laptop-X1>
References: <20220512071819.199873-1-liuhangbin@gmail.com>
 <20220512071819.199873-2-liuhangbin@gmail.com>
 <CAEf4BzZuj90MFaXci3av2BF+=m-P26Y3Zer8TogBiZ8fYsYP=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZuj90MFaXci3av2BF+=m-P26Y3Zer8TogBiZ8fYsYP=g@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 02:58:05PM -0700, Andrii Nakryiko wrote:
> > -TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read $(OUTPUT)/bpf_testmod.ko \
> > -                      ima_setup.sh                                     \
> > +TRUNNER_EXTRA_BUILD := $(OUTPUT)/urandom_read $(OUTPUT)/bpf_testmod.ko \
> >                        $(wildcard progs/btf_dump_test_case_*.c)
> 
> 
> note that progs/btf_dump_test_case_*.c are not built, they are just
> copied over (C source files), so I don't think this fix is necessary.
> 
> btw, I tried running `OUTPUT="/tmp/bpf" make test_progs` and it didn't
> error out. But tbh, I'd recommend building everything instead of
> building individual targets.

After update the code to latest bpf-next. It works this time, the ima_setup.sh
was copied to target folder correctly. 

  EXT-COPY [test_progs] urandom_read bpf_testmod.ko liburandom_read.so ima_setup.sh btf_dump_test_case_bitfields.c btf_dump_test_case_multidim.c btf_dump_test_case_namespacing.c btf_dump_test_case_ordering.c btf_dump_test_case_packing.c btf_dump_test_case_padding.c btf_dump_test_case_syntax.c
  BINARY   test_progs

Not sure why the previous kernel doesn't work. But anyway I will drop this patch.

On the other hand, when I build with latest bpf-next. I got error like:

"""
# OUTPUT="/tmp/bpf" make test_progs
  BINARY   urandom_read                                                                                                                                                       gcc -g -O0 -rdynamic -Wall -Werror -DHAVE_GENHDR  -I/home/net/tools/testing/selftests/bpf -I/tmp/bpf/tools/include -I/home/net/include/generated -I/home/net/tools/lib -I/home/net/tools/include -I/home/net/tools/include/uapi -I/tmp/bpf  urandom_read.c urandom_read_aux.c  \
          liburandom_read.so -lelf -lz -lrt -lpthread   \
          -Wl,-rpath=. -Wl,--build-id=sha1 -o /tmp/bpf/urandom_read
/usr/bin/ld: cannot find liburandom_read.so: No such file or directory                                                                                                        collect2: error: ld returned 1 exit status
make: *** [Makefile:177: /tmp/bpf/urandom_read] Error 1

# ls /tmp/bpf/liburandom_read.so
/tmp/bpf/liburandom_read.so
"""

after I copy to liburandom_read.so back to tools/testing/selftests/bpf the build
success.

"""
# cp /tmp/bpf/liburandom_read.so /home/net/tools/testing/selftests/bpf/
# gcc -g -O0 -rdynamic -Wall -Werror -DHAVE_GENHDR -I/home/net/tools/testing/selftests/bpf -I/tmp/bpf/tools/include -I/home/net/include/generated -I/home/net/tools/lib -I/home/net/tools/include -I/home/net/tools/include/uapi -I/tmp/bpf  urandom_read.c urandom_read_aux.c liburandom_read.so -lelf -lz -lrt -lpthread -Wl,-rpath=. -Wl,--build-id=sha1 -o /tmp/bpf/urandom_read
# echo $?
0
"""

Do you know why this happens?

Thanks
Hangbin
