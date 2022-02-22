Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6FC84BFE05
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 17:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbiBVQDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 11:03:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiBVQDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 11:03:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0DB710BBEC
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 08:02:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645545766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aWlxW0Ffy7GiFj5YYFldC85tt+zkpLfBTm00ivVWhTQ=;
        b=Kz1jpIMT4tsWbCcNfu/4u5nE1G+ruosseW5dJuglscuaY2nhgKxDlTlTRcvEgk/gcSqdX0
        NRv+4e0gp0X+EsWMsw0YUlZs+iJ3OJFwUaJbo/eDm4WLpDV5bFMHQFnWEzl/ZjSaH8hFKw
        ESap+m3LKv8xuo+612JkL7vMq+DftHM=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-261-xgKvMldPMmS-IG4YRLGZpQ-1; Tue, 22 Feb 2022 11:02:45 -0500
X-MC-Unique: xgKvMldPMmS-IG4YRLGZpQ-1
Received: by mail-io1-f71.google.com with SMTP id 24-20020a5d9c18000000b0064075f4edbdso8894399ioe.19
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 08:02:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:references:mime-version:in-reply-to:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aWlxW0Ffy7GiFj5YYFldC85tt+zkpLfBTm00ivVWhTQ=;
        b=M8/GepaPWG05pgMStVOnNq0uHLiFi+MkygIpHIVAo2kGE4DWVZ8jvrl1qgiJxKtp70
         mV3nCZIwJrE+qTXHGqJsAvBdsrw4VN7ptnopjI8KWCra5dPm6g/oRk0BlK+YIdMmJ4bg
         0abw8PC3rkxDeM6YXJmxkquI7viqOrkmjjlzCH67WlntxG79mktaS9flS630fe3RELrF
         teb4sGZboCpIa+tSqabr7zRq/IhDjabDTxcse53zkkSZeWRtGYGaDrA8Ie423qvtwm4s
         C47uvJ6Xqrt8y9FVO62yF9fe3nYrJ9cijcnrgm6Ju/m75N0eyGT3qLNz4MMyf7+j7530
         geAw==
X-Gm-Message-State: AOAM5330GA6869ItKBsts1aVO/5cEG1xeqGOL4NY7kYllKDSSk4p2YM+
        M6k4JD/CXLF3d3AVeom649TpPbLWAtlyFKfQQ7mYHSIJpQzW+8oQTqICu0+9I4aGdSaXc9oDvxK
        67vsTP33XoloGmaaO3ab4qWcstMTzqutT
X-Received: by 2002:a05:6638:92a:b0:314:ed12:9b3d with SMTP id 10-20020a056638092a00b00314ed129b3dmr7612942jak.229.1645545764572;
        Tue, 22 Feb 2022 08:02:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxVbJrbGtQ+w+uSx/CWNALtztAgll4f/9v7xzpQUdSzVFT+tBPexLuu0mv0iNKgT2UIAQwtP60mVowRtGFnCkA=
X-Received: by 2002:a05:6638:92a:b0:314:ed12:9b3d with SMTP id
 10-20020a056638092a00b00314ed129b3dmr7612911jak.229.1645545764006; Tue, 22
 Feb 2022 08:02:44 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 22 Feb 2022 08:02:43 -0800
From:   Marcelo Leitner <mleitner@redhat.com>
References: <b17b6504-49be-72b5-8f09-d50e4db4881b@ovn.org> <DE808EB4-983E-47B1-8B72-2EDEEC86FBE6@redhat.com>
 <fd03a6b9-2ccb-f6d1-038b-c23b3a7827f1@ovn.org> <D7348910-0483-41A7-BD96-83CB364650D1@redhat.com>
 <7977b95b-aeb2-99ab-5b12-c65d811b765d@ovn.org> <CALnP8ZbdEYiecU9rm3jYg4jA=ca0Os7+==6Dn_UiDRtn9-pMRg@mail.gmail.com>
 <D5709C71-4CE5-47F2-AE3E-B8D91B57DAA3@redhat.com> <81CEDA74-119C-48E2-89B9-E0C1CC09E95B@redhat.com>
 <CALnP8ZZ251hppTzAYVmKzB7WeLTniLVQ-dXePJGekvyBcGLckg@mail.gmail.com> <C786EF01-87A3-4471-80E3-CB18B7A4E572@redhat.com>
MIME-Version: 1.0
In-Reply-To: <C786EF01-87A3-4471-80E3-CB18B7A4E572@redhat.com>
Date:   Tue, 22 Feb 2022 08:02:43 -0800
Message-ID: <CALnP8ZZ7qX_7EtXhVXaE_4pnsJHjmrzFfq7U+OQZkR_zV8_72g@mail.gmail.com>
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

On Tue, Feb 22, 2022 at 04:44:30PM +0100, Eelco Chaudron wrote:
>
>
> On 22 Feb 2022, at 12:36, Marcelo Leitner wrote:
>
> > +Cc Wenxu, Paul and netdev
> >
> > On Tue, Feb 22, 2022 at 10:33:44AM +0100, Eelco Chaudron wrote:
> >>
> >>
> >> On 21 Feb 2022, at 15:53, Eelco Chaudron wrote:
> >>
> >>> On 21 Feb 2022, at 14:33, Marcelo Leitner wrote:
> >>
> >> <SNIP>
> >>
> >>>>>> Don=E2=80=99t think this is true, it will only print if +trk and a=
ny other flags are set.
> >>>>>> Guess this is where the miscommunication is.>
> >>>>>>> The message also seems to be a bit aggressive, especially since i=
t will
> >>>>>>> almost always be printed.
> >>>>>
> >>>>> Yeah.  I missed the fact that you're checking for zero and flower->=
key.ct_state
> >>>>> will actually mark existence of other flags.  So, that is fine.
> >>>>>
> >>>>> However, I'm still not sure that the condition is fully correct.
> >>>>>
> >>>>> If we'll take a match on '+est' with all other flags wildcarded, th=
at will
> >>>>> trigger the condition, because 'flower->key.ct_state' will contain =
the 'est' bit,
> >>>>> but 'trk' bit will not be set.  The point is that even though -trk+=
est is not
> >>>>
> >>>> Oh ow. tc flower will reject this combination today, btw. I don't kn=
ow
> >>>> about hw implications for changing that by now.
> >>>>
> >>>> https://elixir.bootlin.com/linux/latest/C/ident/fl_validate_ct_state
> >>>> 'state' parameter in there is the value masked already.
> >>>>
> >>>> We directly mapped openflow restrictions to the datapath.
> >>>>
> >>>>> a valid combination and +trk+est is, OVS may in theory produce the =
match with
> >>>>> 'est' bit set and 'trk' bit wildcarded.  And that can be a correct =
configuration.
> >>>>
> >>>> I guess that means that the only possible parameter validation on
> >>>> ct_state at tc level is about its length. Thoughts?
> >>>>
> >>>
> >>> Guess I get it now also :) I was missing the wildcard bit that OVS im=
plies when not specifying any :)
> >>>
> >>> I think I can fix this by just adding +trk on the TC side when we get=
 the OVS wildcard for +trk. Guess this holds true as for TC there is no -tr=
k +flags.
> >>>
> >>> I=E2=80=99m trying to replicate patch 9 all afternoon, and due to the=
 fact I did not write down which test was causing the problem, and it takin=
g 20-30 runs, it has not happened yet :( But will do it later tomorrow, see=
 if it works in all cases ;)
> >>>
> >>
> >> So I=E2=80=99ve been doing some experiments (and running all system-tr=
affic tests), and I think the following fix will solve the problem by just =
making sure the +trk flag is set in this case on the TC side.
> >> This will not change the behavior compared to the kernel.
> >>
> >> diff --git a/lib/netdev-offload-tc.c b/lib/netdev-offload-tc.c
> >> index 0105d883f..3d2c1d844 100644
> >> --- a/lib/netdev-offload-tc.c
> >> +++ b/lib/netdev-offload-tc.c
> >> @@ -1541,6 +1541,12 @@ parse_match_ct_state_to_flower(struct tc_flower=
 *flower, struct match *match)
> >>              flower->key.ct_state &=3D ~(TCA_FLOWER_KEY_CT_FLAGS_NEW);
> >>              flower->mask.ct_state &=3D ~(TCA_FLOWER_KEY_CT_FLAGS_NEW)=
;
> >>          }
> >> +
> >> +        if (flower->key.ct_state &&
> >> +            !(flower->key.ct_state & TCA_FLOWER_KEY_CT_FLAGS_TRACKED)=
) {
> >> +            flower->key.ct_state |=3D TCA_FLOWER_KEY_CT_FLAGS_TRACKED=
;
> >> +            flower->mask.ct_state |=3D TCA_FLOWER_KEY_CT_FLAGS_TRACKE=
D;
> >> +        }
> >
> > I had meant to update the kernel instead. As Ilya was saying, as this
> > is dealing with masks, the validation that tc is doing is not right. I
> > mean, for a connection to be in +est, it needs +trk, right, but for
> > matching, one could have the following value/mask:
> >  value=3Dest
> >  mask=3Dest
> > which means: match connections in Established AND also untracked ones.
>
> Maybe it was too late last night, but why also untracked ones?

Nah, it was too early today here. :D

> It should only match untracked ones with the est flag set, or do I miss s=
omething?
> Untracked ones can never have the est flag set, right?

My bad. Please scratch that description. Right.. it can't match
untracked ones because it's checking that est is set, and untracked
ones can never have it.

Yet, the point is, the mask, per say, is not wrong. All conntrack
entries that have +est will also have +trk, okay, but a user filtering
only for +est is not wrong and tc shouldn't reject it.

I couldn't find a similar verification in ovs kernel. Maybe I missed
it. But if vswitchd would need the tweak in here, seems ovs kernel
doesn't need it, and then the two would potentially have different
behaviours.

>
> > Apparently this is what the test is triggering here, and the patch
> > above could lead to not match the 2nd part of the AND above.
> >
> > When fixing the parameter validation in flower, we went too far.
> >
> >   Marcelo
> >
> >>      }
> >>
> >> I will send out a v3 of this set soon with this change included.
> >>
> >> //Eelco
> >>
> >> <SNIP>
> >>
>

