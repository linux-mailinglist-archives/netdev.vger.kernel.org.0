Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69EE738DB17
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 13:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbhEWL4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 07:56:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43735 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231757AbhEWL4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 07:56:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621770893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=reAL8qaXYapkCFhm8jjL7wq/h/cOzNZpVMh15jTydhs=;
        b=FuJ5yJiSyp/L2Icj8oLrpEV9hg3hplBgbU7+2qQUVBXf/AwlqUlxUlWO4kEDQWi7bo3un0
        B4s8N4XqeYNCQ4KcqAuwdoYVpq5kT7jkU1ZX/scR08cCnahU7Dn8MzoOtXfhQ1WchaJG1/
        jfZn4C8BERqVFgtFp94EjLUXV0RmgaE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-9-70ZRBEOeelysllKeDSew-1; Sun, 23 May 2021 07:54:50 -0400
X-MC-Unique: 9-70ZRBEOeelysllKeDSew-1
Received: by mail-ed1-f72.google.com with SMTP id cy15-20020a0564021c8fb029038d26976787so12555169edb.0
        for <netdev@vger.kernel.org>; Sun, 23 May 2021 04:54:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=reAL8qaXYapkCFhm8jjL7wq/h/cOzNZpVMh15jTydhs=;
        b=DVi/A89EqJJ1X2lmFVTeGRPv8WMPnVH0KaXmlWJ7y4I7/GHRniyMsAGMXSJB0hVe/J
         +KvHMXFaN9W4j5uA5ocx+35+2QMQ0Gc6paQLNDHjoVwrtxv5ch+X47VJnrBf5h9n0gEb
         wRC1EWM0jvEK2PpdjOSSzQn6dyW9kUfGw5xHDhuTAo3Otzfv+NhESXkm/eBsPH+nX6jk
         lgMEAjxiUaO4kVuO52H1DwtqCf+mXUWyYOuZzNPplqt+yDjTe9JRXf0Mm5JiUU6RYJBJ
         i1YKlLEtXP2DG/IgZropBPopvv7azUewUnqx+MqCEoXluOG+XfvrWci0f41nD7Qxkv5S
         JiXw==
X-Gm-Message-State: AOAM533ktX3zRpvqs9nNGnG5Dd7PysUdRQyfzuAYu76M+aPc3QRJe2U4
        03Xp0Owuaf6MZ1zKAfuvTOoAxHGfxPO1FOqresATd3jCp7Pr6TB8OrT+k4VBR49EC4XZ41x8gSV
        cOTF+UV0YBsrgWg9n
X-Received: by 2002:a17:906:4089:: with SMTP id u9mr18366636ejj.18.1621770889339;
        Sun, 23 May 2021 04:54:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzgnqjKWAHgF5FTEMAe/6phFrZ7mr91DmRYzW3rgXTajP6tFjC78r/xscENE0hOx3yC45BgJA==
X-Received: by 2002:a17:906:4089:: with SMTP id u9mr18366627ejj.18.1621770889121;
        Sun, 23 May 2021 04:54:49 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.95.13])
        by smtp.gmail.com with ESMTPSA id yr15sm6572478ejb.16.2021.05.23.04.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 04:54:48 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 75BD81801D6; Sun, 23 May 2021 13:54:47 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Saeed Mahameed <saeed@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>
Cc:     "Raczynski, Piotr" <piotr.raczynski@intel.com>,
        "Zhang, Jessica" <jessica.zhang@intel.com>,
        "Kubiak, Marcin" <marcin.kubiak@intel.com>,
        "Joseph, Jithu" <jithu.joseph@intel.com>,
        "kurt@linutronix.de" <kurt@linutronix.de>,
        "Maloor, Kishen" <kishen.maloor@intel.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Swiatkowski, Michal" <michal.swiatkowski@intel.com>,
        "Plantykow, Marta A" <marta.a.plantykow@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Desouza, Ederson" <ederson.desouza@intel.com>,
        "Song, Yoong Siang" <yoong.siang.song@intel.com>,
        "Czapnik, Lukasz" <lukasz.czapnik@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: AF_XDP metadata/hints
In-Reply-To: <1426bc91c6c6ee3aaf3d85c4291a12968634e521.camel@kernel.org>
References: <dc2c38cdccfa5eca925cfc9d59b0674e208c9c9d.camel@intel.com>
 <DM6PR11MB2780A8C5410ECB3C9700EAB5CA579@DM6PR11MB2780.namprd11.prod.outlook.com>
 <PH0PR11MB487034313697F395BB5BA3C5E4579@PH0PR11MB4870.namprd11.prod.outlook.com>
 <DM4PR11MB5422733A87913EFF8904C17184579@DM4PR11MB5422.namprd11.prod.outlook.com>
 <20210507131034.5a62ce56@carbon>
 <DM4PR11MB5422FE9618B3692D48FCE4EA84549@DM4PR11MB5422.namprd11.prod.outlook.com>
 <20210510185029.1ca6f872@carbon>
 <DM4PR11MB54227C25DFD4E882CB03BD3884539@DM4PR11MB5422.namprd11.prod.outlook.com>
 <20210512102546.5c098483@carbon>
 <DM4PR11MB542273C9D8BF63505DC6E21784519@DM4PR11MB5422.namprd11.prod.outlook.com>
 <7b347a985e590e2a422f837971b30bd83f9c7ac3.camel@nvidia.com>
 <DM4PR11MB5422762E82C0531B92BDF09A842B9@DM4PR11MB5422.namprd11.prod.outlook.com>
 <DM4PR11MB5422269F6113268172B9E26A842A9@DM4PR11MB5422.namprd11.prod.outlook.com>
 <DM4PR11MB54224769926B06EE76635A6484299@DM4PR11MB5422.namprd11.prod.outlook.com>
 <20210521153110.207cb231@carbon>
 <1426bc91c6c6ee3aaf3d85c4291a12968634e521.camel@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sun, 23 May 2021 13:54:47 +0200
Message-ID: <87lf85zmuw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Saeed Mahameed <saeed@kernel.org> writes:

> On Fri, 2021-05-21 at 15:31 +0200, Jesper Dangaard Brouer wrote:
>> On Fri, 21 May 2021 10:53:40 +0000
>> "Lobakin, Alexandr" <alexandr.lobakin@intel.com> wrote:
>>=20
>> > I've opened two discussions at https://github.com/alobakin/linux,
>> > feel free to join them and/or create new ones to share your thoughts
>> > and concerns.
>>=20
>> Thanks Alexandr for keeping the thread/subject alive.
>> =C2=A0
>> I guess this is a new GitHub features "Discussions".=C2=A0 I've never us=
ed
>> that in a project before, lets see how this goes.=C2=A0 The usual approa=
ch
>> is discussions over email on netdev (Cc. netdev@vger.kernel.org).
>
> I agree we need full visibility and transparency, i actually recommend:
> bpf@vger.kernel.org

+1, please keep this on the list :)

-Toke

