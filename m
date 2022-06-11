Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5307E5473FE
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 12:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiFKKzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 06:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiFKKzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 06:55:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C92C58E67
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 03:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654944908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yFarg/JFfmBNFzZqU7SVjcMF+Jom9vKZA2S1tn659A4=;
        b=SSQFHU3esWqeSqat1nX7FOFilwxVg1U0+8/KBHU9ZlVDFRLH+GFBz/uQQD0eUyS/TCoLjV
        t1AVtg7nzpAUHshlAYv36sDbqS/BDlmVsYkQqeefWf8bU4X4MWNH+nQKfwrgyq0wzaPn6F
        agM3OksMOthxD5Hsp7hwXgnsSFdS2mo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-173-HcBRnoJmN7GHPDo6mlG9AQ-1; Sat, 11 Jun 2022 06:55:06 -0400
X-MC-Unique: HcBRnoJmN7GHPDo6mlG9AQ-1
Received: by mail-ed1-f72.google.com with SMTP id j4-20020aa7ca44000000b0042dd12a7bc5so1139189edt.13
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 03:55:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=yFarg/JFfmBNFzZqU7SVjcMF+Jom9vKZA2S1tn659A4=;
        b=XmEgoYketdiXyBaQVl6AwRJXKk1lteCRHLrFHEyHsuJUuDq3peDaz81Jx0FtDeUc6x
         2HAbRO9Cr08kCNKU/Sy/Y/irCctD5O78k/XllyrKml3qzEB6FhVhV0NZ4gPk9JOUfA8U
         dyC/8Xd0W91GdcQG2o1gImKksiD8eAhprm10qpVLaf7lTklRQIp9W9FpD4zdvD1yOHZ4
         +3enV+oZUF9DtjmT9CHi33I+IOyUpx3HXj2qbv6Z7Qga+Z+ww5cY7jT8/bqYedT3H/GN
         JpDAEh9eODS1DBaSdMhNY7MUIh55Lb3Ul6rFSQ6GKlbcDqdTLOK7uVQFc7mW2MN7ylrE
         ywVg==
X-Gm-Message-State: AOAM533ogDRn/4wKzmde5xwNAW131UMM+BGjInZYv0xwqety14YfwYg7
        DaiWSNIMEcLQ72LNInU6wfwFGSxEts13acYcw9QPS99YwhDzma6o2hLsb12yHittZsHs3m6KhFX
        SAee+7mM8/b0RghsL
X-Received: by 2002:a17:906:7a57:b0:711:faf1:587d with SMTP id i23-20020a1709067a5700b00711faf1587dmr14215393ejo.581.1654944902947;
        Sat, 11 Jun 2022 03:55:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytlhudXWd+3Uadbouwxe3Valh4oMzxQ4EpolAY9C86PXPXsU4CompTcUT3ZFItHpMgyqjkBw==
X-Received: by 2002:a17:906:7a57:b0:711:faf1:587d with SMTP id i23-20020a1709067a5700b00711faf1587dmr14215262ejo.581.1654944900415;
        Sat, 11 Jun 2022 03:55:00 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id h8-20020aa7c5c8000000b0042e21f8c412sm1205389eds.42.2022.06.11.03.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jun 2022 03:54:59 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id F2637406475; Sat, 11 Jun 2022 12:54:58 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 0/7] Add bpf_link based TC-BPF API
In-Reply-To: <15bdc24c-fe85-479a-83fe-921da04cb6b1@iogearbox.net>
References: <20210604063116.234316-1-memxor@gmail.com>
 <CAJnrk1YJe-wtXFF0U2cuZUdd-gH1Y80Ewf3ePo=vh-nbsSBZgg@mail.gmail.com>
 <20220610125830.2tx6syagl2rphl35@apollo.legion>
 <CAJnrk1YCBn2EkVK89f5f3ijFYUDhLNpjiH8buw8K3p=JMwAc1Q@mail.gmail.com>
 <CAJnrk1YCSaRjd88WCzg4ccv59h0Dn99XXsDDT4ddzz4UYiZmbg@mail.gmail.com>
 <20220610193418.4kqpu7crwfb5efzy@apollo.legion> <87h74s2s19.fsf@toke.dk>
 <2f98188b-813b-e226-4962-5c2848998af2@iogearbox.net>
 <87bkv02qva.fsf@toke.dk>
 <CAADnVQLbC-KVNRPgbJP3rokgLELam5ao1-Fnpej8d-9JaHMJPA@mail.gmail.com>
 <15bdc24c-fe85-479a-83fe-921da04cb6b1@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 11 Jun 2022 12:54:58 +0200
Message-ID: <874k0r31x9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 6/10/22 11:52 PM, Alexei Starovoitov wrote:
>> On Fri, Jun 10, 2022 at 1:41 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
>>>
>>>>> Except we'd want to also support multiple programs on different
>>>>> priorities? I don't think requiring a libxdp-like dispatcher to achie=
ve
>>>>> this is a good idea if we can just have it be part of the API from the
>>>>> get-go...
>>>>
>>>> Yes, it will be multi-prog to avoid a situation where dispatcher is ne=
eded.
>>>
>>> Awesome! :)
>>=20
>> Let's keep it simple to start.
>> Priorities or anything fancy can be added later if really necessary.
>> Otherwise, I'm afraid, we will go into endless bikeshedding
>> or the best priority scheme.
>>=20
>> A link list of bpf progs like cls_bpf with the same semantics as
>> cls_bpf_classify.
>> With prog->exts_integrated always true and no classid, since this
>> concept doesn't apply.
> Yes, semantics must be that TC_ACT_UNSPEC continues in the list and
> everything else as return code would terminate the evaluation.

Sure, SGTM!

-Toke

