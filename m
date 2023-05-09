Return-Path: <netdev+bounces-1117-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 968876FC3F2
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:33:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A3F61C20B28
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:33:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34ECC567F;
	Tue,  9 May 2023 10:33:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295447C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 10:33:11 +0000 (UTC)
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7648359F7
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 03:32:54 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id d75a77b69052e-3ef34c49cb9so108701cf.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 03:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683628373; x=1686220373;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qcGQV8URVewXhceHdRTKUxgoNq0QeCUK4Rv0JS8wEOE=;
        b=T09Im7i7ysHKPdVccUiHo3ZoE05Aqvalb6fcpX7w1wpcPxoGYPe3+FKsOJlWwI0uch
         vqoyvDpfLb2DkizQ1cO77fFkNFQ5Gj9z+1MXBnHjoHx2HFWSt+SpwiOfPQElSNr6oCP8
         V3AGpMOhcyUYNZGoVR3l6OUFUfry0rNV/e71nYS/ZGCM9/J4+3cV6MMgppr7eJB0oNUW
         6JeqjzD88nwQjutq31uQRhgEHsxfzZYlNabCw9ZbebxHFw3MJAF9ZYoW5MTdE8po7Vl2
         5S5wwGuAU1JT4w684Sc+MTvicg0fkWqRrUkoTHXhtmHanY8pY0rDuvBRjqMO5RhiEpIO
         +5Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683628373; x=1686220373;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qcGQV8URVewXhceHdRTKUxgoNq0QeCUK4Rv0JS8wEOE=;
        b=Ane6VMUMi6ePh8RYM+vpUeVlG5ADb37wLmj+6oksBpAS1SKp/AZG4Q2loGDtA8kTNA
         +T1N+2I37jfh8q79DKq+xTlta4oIlKSH1qUW1dvUAqyGUpdGnN1mwEi7TEBjmVlun1gE
         Q5ooyMwGnDgI7nNQOWw/rsw2GUGl5wB61JRcqigg1XPYq4FmrW41AQ8LDOXcO2we0JlQ
         Gpkp2chNWrl7iTcakFWyfNd6bdhTotjajarO/OvRwUD1rSb91IEWFJd4Ugweu+RE/EmF
         kEJsN/u4KeHLzs1XesxnTYP7s3cFuF1KbClBPmEpTKHDUB/IvzdV29tEgoICxfqy38TW
         +EEg==
X-Gm-Message-State: AC+VfDzSl5yW6Pe+iqzoz9FysYvpFAT24/0eyJRjN7Ho0YYH+KdcsyiL
	rkskMkyHZylVdZ/fyXbIqCtVnAgbAb49pwjOHfrshA==
X-Google-Smtp-Source: ACHHUZ4Ei3RmD6wNqyVELS8q5y/nBckaSCaundw7B/nkugPrf0InyC8oGQPuvzedBBNkrxU6N/h7+b2XdRvIk0587Vk=
X-Received: by 2002:a05:622a:201:b0:3ef:19fe:230d with SMTP id
 b1-20020a05622a020100b003ef19fe230dmr177982qtx.17.1683628373392; Tue, 09 May
 2023 03:32:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <371A6638-8D92-4891-8DF5-C0EA4FBC1977@gmail.com> <ZFoeZLOZbNZPUfcg@shredder>
In-Reply-To: <ZFoeZLOZbNZPUfcg@shredder>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 9 May 2023 12:32:40 +0200
Message-ID: <CANn89i+=gWwebCHk2qwu12qC+yXTFUqOxWTfnqbJOAFjidcYeg@mail.gmail.com>
Subject: Re: Very slow remove interface from kernel
To: Ido Schimmel <idosch@idosch.org>
Cc: Martin Zaharinov <micron10@gmail.com>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 9, 2023 at 12:20=E2=80=AFPM Ido Schimmel <idosch@idosch.org> wr=
ote:
>
> On Tue, May 09, 2023 at 11:22:13AM +0300, Martin Zaharinov wrote:
> > add vlans :
> > for i in $(seq 2 4094); do ip link add link eth1 name vlan$i type vlan =
id $i; done
> > for i in $(seq 2 4094); do ip link set dev vlan$i up; done
> >
> >
> > and after that run :
> >
> > for i in $(seq 2 4094); do ip link del link eth1 name vlan$i type vlan =
id $i; done
> >
> >
> > time for remove for this 4093 vlans is 5-10 min .
> >
> > Is there options to make fast this ?
>
> If you know you are going to delete all of them together, then you can
> add them to the same group during creation:
>
> for i in $(seq 2 4094); do ip link add link eth1 name vlan$i up group 10 =
type vlan id $i; done
>
> Then delete the group:
>
> ip link del group 10
>

Another way is to create a netns for retiring devices,
move devices to the 'retirens' when they need to go away.

Then once per minute, delete the retirens and create a new one.

-> This batches netdev deletions.


> IIRC, in the past there was a patchset to allow passing a list of
> ifindexes instead of a group number, but it never made its way upstream.

