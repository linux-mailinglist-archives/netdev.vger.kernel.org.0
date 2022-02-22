Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287924BF750
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 12:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbiBVLgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 06:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiBVLge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 06:36:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A4164135712
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 03:36:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645529768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xYBkRwZLeHPhx1322SebjPyt91384gXAdvnDLNXcpP4=;
        b=aoau3V/qKF6JZNuAuKsAjNoGMU2zKwGe9v53ZD7FM23ZFHgvfL7P4x/zIvY2qmHyLjQUtO
        WXJf94oMR4T5CM1Bf+rUcnh5sxRe4cAXlMRKgHQMYk9FsOJj82yCE6Uvbx5dDT7r9OmUJN
        yOj3+Wl7MHn9+YKNBDnnBCWwQXoeZis=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-231-WrbzoeIwOwSnW2euQAVqmA-1; Tue, 22 Feb 2022 06:36:07 -0500
X-MC-Unique: WrbzoeIwOwSnW2euQAVqmA-1
Received: by mail-io1-f69.google.com with SMTP id z9-20020a6be009000000b00640d453b0fdso5196180iog.8
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 03:36:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:references:mime-version:in-reply-to:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xYBkRwZLeHPhx1322SebjPyt91384gXAdvnDLNXcpP4=;
        b=7ZwMtYkndEPs6aZzJunh+S09IfSHx0o7Q3dI0NGUha2iJQ14P7uP9K2KEuWIbcvtti
         Das4Rw1x4iSsNcVTrMf8Saw8J73oafV9Nmm9+P1EgqvvQbw4Y4g4iB4g3yToQ/4kQ2xt
         uic6i0lfrJ+xdV7FVC4sYGleNEvn/HbS+sedC0FmJsupUwqUOfelGPDG4GK1kXaDhsk1
         mC35VH/5Q2TxfT3//Bpud4SMsWs+9nE/2htVs0FHozxt5frKYjyeKkLX+Vyrxg51Mr1+
         Ujn0kqK6EJjsR43jvwVfIcUf9sg7yHjlsDYJoxW9lj22SVqB8MRGseYkDcNiicp4myCK
         ETNQ==
X-Gm-Message-State: AOAM530O67iZubDRZq3I0LEdFRvjS+iUMWkubp1YIOhT1iQ6bipURYNi
        7KCuSCwavtvZNUNrte6cVEFk7pOblQehQU3watHDKwQSvT/2TlN1GNitOuuByPt8Eq+j1DleKzZ
        eEEmz9khSoEkqNAeC1L7R3cjalvlbw6QE
X-Received: by 2002:a6b:c98f:0:b0:637:fd11:42a0 with SMTP id z137-20020a6bc98f000000b00637fd1142a0mr18973275iof.48.1645529766595;
        Tue, 22 Feb 2022 03:36:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwSOkSsHfLcUoxB4fhkMRjGXgjL5H/5yR5bIKrAllq5tQDoX3z0izR7ouNpR5Bf0SVC0gtc3JT2SjYux9PVhZ4=
X-Received: by 2002:a6b:c98f:0:b0:637:fd11:42a0 with SMTP id
 z137-20020a6bc98f000000b00637fd1142a0mr18973250iof.48.1645529766266; Tue, 22
 Feb 2022 03:36:06 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 22 Feb 2022 03:36:05 -0800
From:   Marcelo Leitner <mleitner@redhat.com>
References: <164362511347.2824752.11751862323892747321.stgit@ebuild>
 <164362638101.2824752.17865423163106515072.stgit@ebuild> <b17b6504-49be-72b5-8f09-d50e4db4881b@ovn.org>
 <DE808EB4-983E-47B1-8B72-2EDEEC86FBE6@redhat.com> <fd03a6b9-2ccb-f6d1-038b-c23b3a7827f1@ovn.org>
 <D7348910-0483-41A7-BD96-83CB364650D1@redhat.com> <7977b95b-aeb2-99ab-5b12-c65d811b765d@ovn.org>
 <CALnP8ZbdEYiecU9rm3jYg4jA=ca0Os7+==6Dn_UiDRtn9-pMRg@mail.gmail.com>
 <D5709C71-4CE5-47F2-AE3E-B8D91B57DAA3@redhat.com> <81CEDA74-119C-48E2-89B9-E0C1CC09E95B@redhat.com>
MIME-Version: 1.0
In-Reply-To: <81CEDA74-119C-48E2-89B9-E0C1CC09E95B@redhat.com>
Date:   Tue, 22 Feb 2022 03:36:05 -0800
Message-ID: <CALnP8ZZ251hppTzAYVmKzB7WeLTniLVQ-dXePJGekvyBcGLckg@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH v2 08/10] netdev-offload-tc: Check for none
 offloadable ct_state flag combination
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     Ilya Maximets <i.maximets@ovn.org>, dev@openvswitch.org,
        Roi Dayan <roid@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        wenxu <wenxu@ucloud.cn>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Cc Wenxu, Paul and netdev

On Tue, Feb 22, 2022 at 10:33:44AM +0100, Eelco Chaudron wrote:
>
>
> On 21 Feb 2022, at 15:53, Eelco Chaudron wrote:
>
> > On 21 Feb 2022, at 14:33, Marcelo Leitner wrote:
>
> <SNIP>
>
> >>>> Don=E2=80=99t think this is true, it will only print if +trk and any=
 other flags are set.
> >>>> Guess this is where the miscommunication is.>
> >>>>> The message also seems to be a bit aggressive, especially since it =
will
> >>>>> almost always be printed.
> >>>
> >>> Yeah.  I missed the fact that you're checking for zero and flower->ke=
y.ct_state
> >>> will actually mark existence of other flags.  So, that is fine.
> >>>
> >>> However, I'm still not sure that the condition is fully correct.
> >>>
> >>> If we'll take a match on '+est' with all other flags wildcarded, that=
 will
> >>> trigger the condition, because 'flower->key.ct_state' will contain th=
e 'est' bit,
> >>> but 'trk' bit will not be set.  The point is that even though -trk+es=
t is not
> >>
> >> Oh ow. tc flower will reject this combination today, btw. I don't know
> >> about hw implications for changing that by now.
> >>
> >> https://elixir.bootlin.com/linux/latest/C/ident/fl_validate_ct_state
> >> 'state' parameter in there is the value masked already.
> >>
> >> We directly mapped openflow restrictions to the datapath.
> >>
> >>> a valid combination and +trk+est is, OVS may in theory produce the ma=
tch with
> >>> 'est' bit set and 'trk' bit wildcarded.  And that can be a correct co=
nfiguration.
> >>
> >> I guess that means that the only possible parameter validation on
> >> ct_state at tc level is about its length. Thoughts?
> >>
> >
> > Guess I get it now also :) I was missing the wildcard bit that OVS impl=
ies when not specifying any :)
> >
> > I think I can fix this by just adding +trk on the TC side when we get t=
he OVS wildcard for +trk. Guess this holds true as for TC there is no -trk =
+flags.
> >
> > I=E2=80=99m trying to replicate patch 9 all afternoon, and due to the f=
act I did not write down which test was causing the problem, and it taking =
20-30 runs, it has not happened yet :( But will do it later tomorrow, see i=
f it works in all cases ;)
> >
>
> So I=E2=80=99ve been doing some experiments (and running all system-traff=
ic tests), and I think the following fix will solve the problem by just mak=
ing sure the +trk flag is set in this case on the TC side.
> This will not change the behavior compared to the kernel.
>
> diff --git a/lib/netdev-offload-tc.c b/lib/netdev-offload-tc.c
> index 0105d883f..3d2c1d844 100644
> --- a/lib/netdev-offload-tc.c
> +++ b/lib/netdev-offload-tc.c
> @@ -1541,6 +1541,12 @@ parse_match_ct_state_to_flower(struct tc_flower *f=
lower, struct match *match)
>              flower->key.ct_state &=3D ~(TCA_FLOWER_KEY_CT_FLAGS_NEW);
>              flower->mask.ct_state &=3D ~(TCA_FLOWER_KEY_CT_FLAGS_NEW);
>          }
> +
> +        if (flower->key.ct_state &&
> +            !(flower->key.ct_state & TCA_FLOWER_KEY_CT_FLAGS_TRACKED)) {
> +            flower->key.ct_state |=3D TCA_FLOWER_KEY_CT_FLAGS_TRACKED;
> +            flower->mask.ct_state |=3D TCA_FLOWER_KEY_CT_FLAGS_TRACKED;
> +        }

I had meant to update the kernel instead. As Ilya was saying, as this
is dealing with masks, the validation that tc is doing is not right. I
mean, for a connection to be in +est, it needs +trk, right, but for
matching, one could have the following value/mask:
 value=3Dest
 mask=3Dest
which means: match connections in Established AND also untracked ones.

Apparently this is what the test is triggering here, and the patch
above could lead to not match the 2nd part of the AND above.

When fixing the parameter validation in flower, we went too far.

  Marcelo

>      }
>
> I will send out a v3 of this set soon with this change included.
>
> //Eelco
>
> <SNIP>
>

