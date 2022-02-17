Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCC24BA727
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 18:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243731AbiBQRaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 12:30:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbiBQRaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 12:30:21 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54ECD272D8F;
        Thu, 17 Feb 2022 09:30:06 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id y11so251228pfa.6;
        Thu, 17 Feb 2022 09:30:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=S0mP+gQItL0EexL5aPknfQRXrpjtE7gE4U7C9cJtgV0=;
        b=Kz/FLUFB0NDlTmKj99fKKrcnTQeB/fx9Uqw/jTCu6dHipjcBAFoLfekUWSdzw4Hlui
         CIfb35ZI/EwZc2w1inhb02y4CQmXICjByqCDQ2BPY44irZEmjAnMtl3PWbfi8VQoVeYW
         NNLg6pvOxgWyAJbwxhYDOXyVikHxZj++z4AslfVm9w/r1swFlA72K1beNxhQd9MxeUNr
         qWTks3mHfsqk3XVu625gH7iVX2+ueUNpqoR1jinzv9zi69TqHYBbrfdNz8EMwaF8wl/v
         3xupzVGdpvX0kikiXxrfSgYXS5obqL3a9/UCQF33LpHpSfZ7Ev78EK2brmSlLMVF6mz6
         ZOww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=S0mP+gQItL0EexL5aPknfQRXrpjtE7gE4U7C9cJtgV0=;
        b=fayBswHwBkUvy+Ywk9aRXWjUYyq7veoLKX4xn6vIJ72gin5bkdLumm0HOMrovzG0R+
         qCr9Lkqk/Py6VzoylKX9+uS9AYr+9Y024cZ49DxSTqW47ga8EdaFdC1FR/JhUMifMzok
         2Huk5tb3ruOjS8REWvSo/wxX3BZlHBSi/7HQ8zYWNaGi8qS9ymxHgJtJWoIvnhyKzozJ
         GNZxHkUx0mX28YiDG9ILfcEIsKOsCA8p7lIypg7s7tjw0UkF5gd/eLdvqLbrn0bzqrpi
         tPnN73oyrhRElV3Xzz6ov27LZ9viGzyyH5JwozP8BT3CfvftomlBvTHryZeRK+5MBza+
         QvQQ==
X-Gm-Message-State: AOAM533TA2fklPpHkv8SlpBiEeZf8F0wj/y8V8x1wnvqNFwAaJb0bKqM
        8qT7bDbFGZB/tE1IDTu0utsyfRVTNsZ8sr1LWP4=
X-Google-Smtp-Source: ABdhPJyN1tP+rIxNtkLNTBcv8VhNYwdGPrE+6Ix9rpxGp0PA6bghC6wpL1IbAlkx+BCS5PTp2fOUYtendkuCPisvovw=
X-Received: by 2002:a63:f711:0:b0:373:585d:2fd4 with SMTP id
 x17-20020a63f711000000b00373585d2fd4mr3184332pgh.287.1645119005789; Thu, 17
 Feb 2022 09:30:05 -0800 (PST)
MIME-Version: 1.0
References: <20220217145003.78982-1-cgzones@googlemail.com>
In-Reply-To: <20220217145003.78982-1-cgzones@googlemail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 17 Feb 2022 09:29:54 -0800
Message-ID: <CAADnVQJKkrWosMo3S1Ua15_on0S5FWYqUgETi6gqccVOibvEAg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] capability: use new capable_or functionality
To:     =?UTF-8?Q?Christian_G=C3=B6ttsche?= <cgzones@googlemail.com>
Cc:     selinux@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge@hallyn.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Du Cheng <ducheng2@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexey Gladkov <legion@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Rolf Eike Beer <eb@emlix.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Peter Collingbourne <pcc@google.com>,
        Colin Cross <ccross@google.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Xiaofeng Cao <cxfcosmos@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ziyang Xuan <william.xuanziyang@huawei.com>,
        Alexander Aring <aahringo@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alistair Delva <adelva@google.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 6:50 AM Christian G=C3=B6ttsche
<cgzones@googlemail.com> wrote:
>
> Use the new added capable_or macro in appropriate cases, where a task
> is required to have any of two capabilities.
>
> Reorder CAP_SYS_ADMIN last.
>
> TODO: split into subsystem patches.

Yes. Please.

The bpf side picked the existing order because we were aware
of that selinux issue.
Looks like there is no good order that works for all.
So the new helper makes a lot of sense.

> Fixes: 94c4b4fd25e6 ("block: Check ADMIN before NICE for IOPRIO_CLASS_RT"=
)
