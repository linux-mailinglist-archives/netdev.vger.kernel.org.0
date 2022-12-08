Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D1D646A0F
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 09:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiLHIEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 03:04:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLHIEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 03:04:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D8C42F4B
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 00:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670486587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xqXvRbmi7slfDWuHmbRNJXxA21s4PitXI2aBM8lCjLw=;
        b=iBTdUpStzDUwqTec0Rsc6225rWGp5s3SEGHLu1t0o/EMfS4WdGDiKXtzwIGMbwJ/DLZUeg
        K7bepkGJ4dy+ExraY1ubxY6unqkcT0/rdOQcw2FMvdDA8CvJUy5/wGemm003x5TR9WRqBg
        EVMGlPFAhs9k4UHNumbI8kdUqdQcM+o=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-16-bE_xmmTeMa2sTeAcdUFeyg-1; Thu, 08 Dec 2022 03:03:06 -0500
X-MC-Unique: bE_xmmTeMa2sTeAcdUFeyg-1
Received: by mail-ot1-f71.google.com with SMTP id r17-20020a05683001d100b0066ea9f94a39so456353ota.22
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 00:03:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xqXvRbmi7slfDWuHmbRNJXxA21s4PitXI2aBM8lCjLw=;
        b=fVND/f2ecey8FEYVFBm5FFN/jjSFunqVZnP+paBt3CqWeuxcFZaqol1jN1ON5We1wU
         +08hAlovGSdyCRyKJC5Xcpy/o2H21d5eaoNnNOgDAQ56M3HbYSXQBI7rtV0NospgovBS
         Nd0GPtfGtlm9Tw70DKHLGPWwaHp5J7GHxsTSCE9SWuH6umAoCkFAYYrcrQn+2+xg7KqA
         hosnutZotQAqZz5Psy5QciyhpUF7CH4rjjC6XUl29zTmBkGxzzkAo3CzFnpy8qOaRiRa
         4DYXAJi/Qdf5hb7fwrr0HrCTi98BoB6kRapxQ4praZRCWvSFelGPmwd3yChkGiN3gSu5
         RtYQ==
X-Gm-Message-State: ANoB5pmG0jUtuEcoWb9/cu3bsFIedDFiHz3eBj7ZWEMd+RGXAlywTvqK
        c45G9ptt66LXJsLUVmPTH6StdibdKMldWLHoGeLBmROeTC5kA2CS7ItsNuQdPnrC5rzrygR13ye
        Ag6LgNTjhrMVS0hhPwg4QFXMhMqh/Ainf
X-Received: by 2002:aca:1a12:0:b0:35c:303d:fe37 with SMTP id a18-20020aca1a12000000b0035c303dfe37mr7965182oia.35.1670486585211;
        Thu, 08 Dec 2022 00:03:05 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5EjahEeNqTSRcBzyMDtuVr7a0sgCMzWXiKGae/i+ovV0SPdlpHWaXZdZVonFNKwgwsnaAGBbq/kTvCuaPo/R0=
X-Received: by 2002:aca:1a12:0:b0:35c:303d:fe37 with SMTP id
 a18-20020aca1a12000000b0035c303dfe37mr7965176oia.35.1670486584707; Thu, 08
 Dec 2022 00:03:04 -0800 (PST)
MIME-Version: 1.0
References: <20221117033303.16870-1-jasowang@redhat.com> <84298552-08ec-fe2d-d996-d89918c7fddf@oracle.com>
 <CACGkMEtLFTrqdb=MXKovP8gZzTXzFczQSmK0PgzXQTr0Dbr5jA@mail.gmail.com>
 <74909b12-80d5-653e-cd1c-3ea6bc5dbbde@oracle.com> <CACGkMEs7EGUsJ8wtZsj7GEMD9vD6vJNVRUu1fcwUWVYpLUQeZA@mail.gmail.com>
 <d4a85c3b-ab0b-a900-06a9-25abdf264e97@oracle.com> <CACGkMEsN7H4=DqyNWrwLhd+zdfhiYohyB7GmUi8iUH73Z9KxYA@mail.gmail.com>
 <153061e3-4623-38f5-c1b6-3177fc01fcec@oracle.com> <CACGkMEsdC8hfRoCM9bbNRtAbgEPF5FdzfGSoP-OpQ4sckkOMTw@mail.gmail.com>
 <716ae134-f7d9-95d5-5dd4-25434aa01b40@oracle.com>
In-Reply-To: <716ae134-f7d9-95d5-5dd4-25434aa01b40@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 8 Dec 2022 16:02:52 +0800
Message-ID: <CACGkMEsewtht=OfATktidV4eWWpSdndbs0fGjzfSOeHAZuhb-Q@mail.gmail.com>
Subject: Re: [PATCH V2] vdpa: allow provisioning device features
To:     Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     dsahern@kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, mst@redhat.com,
        eperezma@redhat.com, lingshan.zhu@intel.com, elic@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 7, 2022 at 1:12 PM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>
>
>
> On 12/5/2022 7:14 PM, Jason Wang wrote:
> > On Tue, Dec 6, 2022 at 9:43 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
> >>
> >>
> >> On 12/4/2022 10:46 PM, Jason Wang wrote:
> >>> On Thu, Dec 1, 2022 at 8:53 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
> >>>> Sorry for getting back late due to the snag of the holidays.
> >>> No worries :)
> >>>
> >>>> On 11/23/2022 11:13 PM, Jason Wang wrote:
> >>>>> On Thu, Nov 24, 2022 at 6:53 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
> >>>>>> On 11/22/2022 7:35 PM, Jason Wang wrote:
> >>>>>>> On Wed, Nov 23, 2022 at 6:29 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
> >>>>>>>> On 11/16/2022 7:33 PM, Jason Wang wrote:
> >>>>>>>>> This patch allows device features to be provisioned via vdpa. This
> >>>>>>>>> will be useful for preserving migration compatibility between source
> >>>>>>>>> and destination:
> >>>>>>>>>
> >>>>>>>>> # vdpa dev add name dev1 mgmtdev pci/0000:02:00.0 device_features 0x300020000
> >>>>>>>> Miss the actual "vdpa dev config show" command below
> >>>>>>> Right, let me fix that.
> >>>>>>>
> >>>>>>>>> # dev1: mac 52:54:00:12:34:56 link up link_announce false mtu 65535
> >>>>>>>>>            negotiated_features CTRL_VQ VERSION_1 ACCESS_PLATFORM
> >>>>>>>>>
> >>>>>>>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> >>>>>>>>> ---
> >>>>>>>>> Changes since v1:
> >>>>>>>>> - Use uint64_t instead of __u64 for device_features
> >>>>>>>>> - Fix typos and tweak the manpage
> >>>>>>>>> - Add device_features to the help text
> >>>>>>>>> ---
> >>>>>>>>>       man/man8/vdpa-dev.8            | 15 +++++++++++++++
> >>>>>>>>>       vdpa/include/uapi/linux/vdpa.h |  1 +
> >>>>>>>>>       vdpa/vdpa.c                    | 32 +++++++++++++++++++++++++++++---
> >>>>>>>>>       3 files changed, 45 insertions(+), 3 deletions(-)
> >>>>>>>>>
> >>>>>>>>> diff --git a/man/man8/vdpa-dev.8 b/man/man8/vdpa-dev.8
> >>>>>>>>> index 9faf3838..43e5bf48 100644
> >>>>>>>>> --- a/man/man8/vdpa-dev.8
> >>>>>>>>> +++ b/man/man8/vdpa-dev.8
> >>>>>>>>> @@ -31,6 +31,7 @@ vdpa-dev \- vdpa device configuration
> >>>>>>>>>       .I NAME
> >>>>>>>>>       .B mgmtdev
> >>>>>>>>>       .I MGMTDEV
> >>>>>>>>> +.RI "[ device_features " DEVICE_FEATURES " ]"
> >>>>>>>>>       .RI "[ mac " MACADDR " ]"
> >>>>>>>>>       .RI "[ mtu " MTU " ]"
> >>>>>>>>>       .RI "[ max_vqp " MAX_VQ_PAIRS " ]"
> >>>>>>>>> @@ -74,6 +75,15 @@ Name of the new vdpa device to add.
> >>>>>>>>>       Name of the management device to use for device addition.
> >>>>>>>>>
> >>>>>>>>>       .PP
> >>>>>>>>> +.BI device_features " DEVICE_FEATURES"
> >>>>>>>>> +Specifies the virtio device features bit-mask that is provisioned for the new vdpa device.
> >>>>>>>>> +
> >>>>>>>>> +The bits can be found under include/uapi/linux/virtio*h.
> >>>>>>>>> +
> >>>>>>>>> +see macros such as VIRTIO_F_ and VIRTIO_XXX(e.g NET)_F_ for specific bit values.
> >>>>>>>>> +
> >>>>>>>>> +This is optional.
> >>>>>>>> Document the behavior when this attribute is missing? For e.g. inherit
> >>>>>>>> device features from parent device.
> >>>>>>> This is the current behaviour but unless we've found a way to mandate
> >>>>>>> it, I'd like to not mention it. Maybe add a description to say the
> >>>>>>> user needs to check the features after the add if features are not
> >>>>>>> specified.
> >>>>>> Well, I think at least for live migration the mgmt software should get
> >>>>>> to some consistent result between all vdpa parent drivers regarding
> >>>>>> feature inheritance.
> >>>>> It would be hard. Especially for the device:
> >>>>>
> >>>>> 1) ask device_features from the device, in this case, new features
> >>>>> could be advertised after e.g a firmware update
> >>>> The consistency I meant is to always inherit all device features from
> >>>> the parent device for whatever it is capable of,
> >>> This looks fragile. How about the features that are mutually
> >>> exclusive? E.g FEATURE_X and FEATURE_Y that are both supported by the
> >>> mgmt?
> >> Hmmm, in theory, yes, it's a bit cumbersome. Is this for future proof,
> >> since so far as I see the virtio spec doesn't seem to define features
> >> that are mutually exclusive, and the way how driver should respond to
> >> mutually exclusive features in feature negotiation is completely undefined?
> > My understanding is that if a driver accepts two mutually exclusive
> > features it should be a bug.
> It depends on the nature of the specific feature I guess. For e.g. there
> could be two versions of implementation for some device feature, which
> are mutually exclusive. The driver can well selectively ack one of the
> version it supports if seeing both present.
>
> >
> > But anyhow it's an example that it is not easy to have forward
> > compatibility if we mandating to inherit all features from the
> > management device.
>
> Yep, that I agree.
> >
> >>>> since that was the only
> >>>> reasonable behavior pre-dated the device_features attribute, even though
> >>>> there's no mandatory check by the vdpa core. This way it's
> >>>> self-descriptive and consistent for the mgmt software to infer, as users
> >>>> can check into dev_features at the parent mgmtdev level to know what
> >>>> features will be ended up with after 'vdpa dev add'. I thought even
> >>>> though inheritance is not mandated as part of uAPI, it should at least
> >>>> be mentioned as a recommended guide line (for drivers in particular),
> >>>> especially this is the only reasonable behavior with nowhere to check
> >>>> what features are ended up after add (i.e. for now we can only set but
> >>>> not possible to read the exact device_features at vdpa dev level, as yet).
> >>> I fully agree, but what I want to say is. Consider:
> >>>
> >>> 1) We've already had feature provisioning
> >>> 2) It would be hard or even impossible to mandate the semantic
> >>> (consistency) of the features inheritance.
> >>>
> >>> I'm fine with the doc, but the mgmt layer should not depend on this
> >>> and they should use feature provisioning instead.
> >> OK, if it's for future proof to not mandate feature inheritance I think
> >> I see the point.
> >>
> >>>>> 2) or have hierarchy architecture where several layers were placed
> >>>>> between vDPA and the real hardware
> >>>> Not sure what it means but I don't get why extra layers are needed. Do
> >>>> you mean extra layer to validate resulting features during add? Why vdpa
> >>>> core is not the right place to do that?
> >>> Just want to go wild because we can't expect how many layers are below vDPA.
> >>>
> >>> vDPA core is the right place but the validating should be done during
> >>> feature provisioning since it's much more easier than trying to
> >>> mandating code defined behaviour like inheritance.
> >> OK, thanks for the clarifications.
> >>
> >>>>>> This inheritance predates the exposure of device
> >>>>>> features, until which user can check into specific features after
> >>>>>> creation. Imagine the case mgmt software of live migration needs to work
> >>>>>> with older vdpa tool stack with no device_features exposure, how does it
> >>>>>> know what device features are provisioned - it can only tell it from
> >>>>>> dev_features shown at the parent mgmtdev level.
> >>>>> The behavior is totally defined by the code, it would be not safe for
> >>>>> the mgmt layer to depend on. Instead, the mgmt layer should use a
> >>>>> recent vdpa tool with feature provisioning interface to guarantee the
> >>>>> device_features if it wants since it has a clear semantic instead of
> >>>>> an implicit kernel behaviour which doesn't belong to an uAPI.
> >>>> That is going to be a slightly harsh requirement. If there's an existing
> >>>> vDPA setup already provisioned before the device_features work, there is
> >>>> no way for it to live migrate even if the QEMU userspace stack is made
> >>>> live migrate-able. It'd be the best to find some mild alternative before
> >>>> claiming certain setup unmigrate-able.
> >>> It can still work in a passive way, mgmt layer check the device
> >>> features and only allow the migration among the vDPA devices that have
> >>> the same device_feature.
> >> Right, that is the scenario in concern which I'd like to get support
> >> for, even though it's passive due to incompleteness in previous CLI
> >> design (lack of individual device feature provisioning). Once the tool
> >> is upgraded, vdpa features can be provisioned selectively on the
> >> destination node, matching those on the source.
> > This should work, but it probably requires the mgmt layer to collect
> > and compare features among the nodes.
> Yes. I know libvirt probably won't support this. But it would benefit
> other mgmt software implementation, where each node would have to record
> the initial config attributes in the first place. :)
>
> >
> >>>    Less flexible than feature provisioning.
> >>>
> >>>>> If we can mandate the inheriting behaviour, users may be surprised at
> >>>>> the features in the production environment which are very hard to
> >>>>> debug.
> >>>> I'm not against an explicit uAPI to define and guard device_features
> >>>> inheritance, but on the other hand, wouldn't it be necessary to show the
> >>>> actual device_features at vdpa dev level if it's not guaranteed to be
> >>>> the same with that of the parent mgmtdev?
> >>> I think this is already been done ,or anything I miss?
> >> The kernel patch is not merged yet, preventing the userspace patch from
> >> being posted.
> > I may miss something, any potiner here?
> First the following rename patch has to get in to the kernel:
> https://lore.kernel.org/virtualization/1665422823-18364-1-git-send-email-si-wei.liu@oracle.com/
>

Michael, do you plan to merge this?

> then I can post the related iproute patch to include dev_features to the
> output of 'vdpa dev show'.
>
> This initial config series run independently, though the eventual goal
> is to get all of migration compatibility attributes packed in the same
> "initial_config" map.
>
> https://lore.kernel.org/virtualization/1666392237-4042-1-git-send-email-si-wei.liu@oracle.com/

Ok.

> >
> >> While the ideal situation is to allow query of
> >> device_features after adding a vdpa dev (for e.g. if not 100% inherited
> >> from the parent mgmtdev), followed by allowing selectively provision
> >> features individually.
> > Yes.
> >
> >>>> That is even needed before
> >>>> users are allowed to provision specific device_features IMO...
> >>>>
> >>>> (that is the reason why I urged Michael to merge this patch soon before
> >>>> 6.1 GA:
> >>>> https://lore.kernel.org/virtualization/1665422823-18364-1-git-send-email-si-wei.liu@oracle.com/,
> >>>> for which I have a pending iproute patch to expose device_features at
> >>>> 'vdpa dev show' output).
> >>> Right.
> >>>
> >>>>>> IMHO it's not about whether vdpa core can or should mandate it in a
> >>>>>> common place or not, it's that (the man page of) the CLI tool should set
> >>>>>> user's expectation upfront for consumers (for e.g. mgmt software). I.e.
> >>>>>> in case the parent driver doesn't follow the man page doc, it should be
> >>>>>> considered as an implementation bug in the individual driver rather than
> >>>>>> flexibility of its own.
> >>>>> So for the inheriting, it might be too late to do that:
> >>>>>
> >>>>> 1) no facility to mandate the inheriting and even if we had we can't
> >>>>> fix old kernels
> >>>> We don't need to fix any old kernel as all drivers there had obeyed the
> >>>> inheriting rule since day 1. Or is there exception you did see? If so we
> >>>> should treat it as a bug to fix in driver.
> >>> I'm not sure it's a bug consider a vDPA device have only a subset
> >>> feature of what mgmt has.
> >> For example, F_MQ requires F_CTRL_VQ, but today this validation is only
> >> done in individual driver. We should consider consolidating it to the
> >> vdpa core.
> > This needs some balances, the core actually tries to be devince
> > agnostic (though it has some net specific code).
> Yes, this is already the case today. There has been various
> VIRTIO_ID_NET case switch'es in the vdpa.c code. I think if type
> specific validation code just limits itself to the netlink API
> interfacing layer rather than down to the driver API, it might just be
> okay (as that's already the case).

Yes.

>
> > One side effect is that it would be very hard for the core to catch up
> > with the spec development. With the current code, new features could
> > be added without the notice of the core.
> I thought at least the vdpa core can capture those validations already
> defined in the spec. For new development out of spec, driver can be a
> safe place to start.

That's fine, patches are more than welcomed.

Thanks

>
>
> Regards,
> -Siwei
>
> >
> >> But before that happens, if such validation is missing from
> >> driver, we should fix those in vendor drivers first.
> > Yes, that's the way. (E.g virtio-net driver has such validation)
> >
> >>>>> 2) no uAPI so there no entity to carry on the semantic
> >>>> Not against of introducing an explicit uAPI, but what it may end up with
> >>>> is only some validation in a central place, right?
> >>> Well, this is what has been already done right now before the feature
> >>> provisioning, the kernel for anyway needs to validate the illegal
> >>> input from userspace.
> >> Right. What I meant is the kernel validation in vdpa_core should be done
> >> anyway regardless of any new uAPI (for feature inheritance for e.g). I
> >> guess we are in the same page here.
> > Great, I think so.
> >
> > Thanks
> >
> >> Thanks,
> >> -Siwei
> >>
> >>>> Why not do it now
> >>>> before adding device features provisioning to userspace. Such that it's
> >>>> functionality complete and correct no matter if device_features is
> >>>> specified or not.
> >>> So as discussed before, the kernel has already tried to do validation,
> >>> if there's any bug, we can fix that. If you meant userspace
> >>> validation, I'm not sure it is necessary:
> >>>
> >>> 1) kernel should do the validation
> >>> 2) hard to keep forward compatibility, e.g features supported by the
> >>> mgmt device might not be even known by the userspace.
> >>>
> >>> Thanks
> >>>
> >>>> Thanks,
> >>>> -Siwei
> >>>>
> >>>>> And this is one of the goals that feature provisioning tries to solve
> >>>>> so mgmt layer should use feature provisioning instead.
> >>>>>
> >>>>>>>> And what is the expected behavior when feature bit mask is off but the
> >>>>>>>> corresponding config attr (for e.g. mac, mtu, and max_vqp) is set?
> >>>>>>> It depends totally on the parent. And this "issue" is not introduced
> >>>>>>> by this feature. Parents can decide to provision MQ by itself even if
> >>>>>>> max_vqp is not specified.
> >>>>>> Sorry, maybe I wasn't clear enough. The case I referred to was that the
> >>>>>> parent is capable of certain feature (for e.g. _F_MQ), the associated
> >>>>>> config attr (for e.g. max_vqp) is already present in the CLI, but the
> >>>>>> device_features bit mask doesn't have the corresponding bit set (e.g.
> >>>>>> the _F_MQ bit). Are you saying that the failure of this apparently
> >>>>>> invalid/ambiguous/conflicting command can't be predicated and the
> >>>>>> resulting behavior is totally ruled by the parent driver?
> >>>>> Ok, I get you. My understanding is that the kernel should do the
> >>>>> validation at least, it should not trust any configuration that is
> >>>>> sent from the userspace. This is how it works before the device
> >>>>> provisioning. I think we can add some validation in the kernel.
> >>>>>
> >>>>> Thanks
> >>>>>
> >>>>>> Thanks,
> >>>>>> -Siwei
> >>>>>>
> >>>>>>>> I think the previous behavior without device_features is that any config
> >>>>>>>> attr implies the presence of the specific corresponding feature (_F_MAC,
> >>>>>>>> _F_MTU, and _F_MQ). Should device_features override the other config
> >>>>>>>> attribute, or such combination is considered invalid thus should fail?
> >>>>>>> It follows the current policy, e.g if the parent doesn't support
> >>>>>>> _F_MQ, we can neither provision _F_MQ nor max_vqp.
> >>>>>>>
> >>>>>>> Thanks
> >>>>>>>
> >>>>>>>> Thanks,
> >>>>>>>> -Siwei
> >>>>>>>>
> >>>>>>>>> +
> >>>>>>>>>       .BI mac " MACADDR"
> >>>>>>>>>       - specifies the mac address for the new vdpa device.
> >>>>>>>>>       This is applicable only for the network type of vdpa device. This is optional.
> >>>>>>>>> @@ -127,6 +137,11 @@ vdpa dev add name foo mgmtdev vdpa_sim_net
> >>>>>>>>>       Add the vdpa device named foo on the management device vdpa_sim_net.
> >>>>>>>>>       .RE
> >>>>>>>>>       .PP
> >>>>>>>>> +vdpa dev add name foo mgmtdev vdpa_sim_net device_features 0x300020000
> >>>>>>>>> +.RS 4
> >>>>>>>>> +Add the vdpa device named foo on the management device vdpa_sim_net with device_features of 0x300020000
> >>>>>>>>> +.RE
> >>>>>>>>> +.PP
> >>>>>>>>>       vdpa dev add name foo mgmtdev vdpa_sim_net mac 00:11:22:33:44:55
> >>>>>>>>>       .RS 4
> >>>>>>>>>       Add the vdpa device named foo on the management device vdpa_sim_net with mac address of 00:11:22:33:44:55.
> >>>>>>>>> diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
> >>>>>>>>> index 94e4dad1..7c961991 100644
> >>>>>>>>> --- a/vdpa/include/uapi/linux/vdpa.h
> >>>>>>>>> +++ b/vdpa/include/uapi/linux/vdpa.h
> >>>>>>>>> @@ -51,6 +51,7 @@ enum vdpa_attr {
> >>>>>>>>>           VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
> >>>>>>>>>           VDPA_ATTR_DEV_VENDOR_ATTR_NAME,         /* string */
> >>>>>>>>>           VDPA_ATTR_DEV_VENDOR_ATTR_VALUE,        /* u64 */
> >>>>>>>>> +     VDPA_ATTR_DEV_FEATURES,                 /* u64 */
> >>>>>>>>>
> >>>>>>>>>           /* new attributes must be added above here */
> >>>>>>>>>           VDPA_ATTR_MAX,
> >>>>>>>>> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> >>>>>>>>> index b73e40b4..d0ce5e22 100644
> >>>>>>>>> --- a/vdpa/vdpa.c
> >>>>>>>>> +++ b/vdpa/vdpa.c
> >>>>>>>>> @@ -27,6 +27,7 @@
> >>>>>>>>>       #define VDPA_OPT_VDEV_MTU           BIT(5)
> >>>>>>>>>       #define VDPA_OPT_MAX_VQP            BIT(6)
> >>>>>>>>>       #define VDPA_OPT_QUEUE_INDEX                BIT(7)
> >>>>>>>>> +#define VDPA_OPT_VDEV_FEATURES               BIT(8)
> >>>>>>>>>
> >>>>>>>>>       struct vdpa_opts {
> >>>>>>>>>           uint64_t present; /* flags of present items */
> >>>>>>>>> @@ -38,6 +39,7 @@ struct vdpa_opts {
> >>>>>>>>>           uint16_t mtu;
> >>>>>>>>>           uint16_t max_vqp;
> >>>>>>>>>           uint32_t queue_idx;
> >>>>>>>>> +     uint64_t device_features;
> >>>>>>>>>       };
> >>>>>>>>>
> >>>>>>>>>       struct vdpa {
> >>>>>>>>> @@ -187,6 +189,17 @@ static int vdpa_argv_u32(struct vdpa *vdpa, int argc, char **argv,
> >>>>>>>>>           return get_u32(result, *argv, 10);
> >>>>>>>>>       }
> >>>>>>>>>
> >>>>>>>>> +static int vdpa_argv_u64_hex(struct vdpa *vdpa, int argc, char **argv,
> >>>>>>>>> +                          uint64_t *result)
> >>>>>>>>> +{
> >>>>>>>>> +     if (argc <= 0 || !*argv) {
> >>>>>>>>> +             fprintf(stderr, "number expected\n");
> >>>>>>>>> +             return -EINVAL;
> >>>>>>>>> +     }
> >>>>>>>>> +
> >>>>>>>>> +     return get_u64(result, *argv, 16);
> >>>>>>>>> +}
> >>>>>>>>> +
> >>>>>>>>>       struct vdpa_args_metadata {
> >>>>>>>>>           uint64_t o_flag;
> >>>>>>>>>           const char *err_msg;
> >>>>>>>>> @@ -244,6 +257,10 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struct vdpa *vdpa)
> >>>>>>>>>                   mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, opts->max_vqp);
> >>>>>>>>>           if (opts->present & VDPA_OPT_QUEUE_INDEX)
> >>>>>>>>>                   mnl_attr_put_u32(nlh, VDPA_ATTR_DEV_QUEUE_INDEX, opts->queue_idx);
> >>>>>>>>> +     if (opts->present & VDPA_OPT_VDEV_FEATURES) {
> >>>>>>>>> +             mnl_attr_put_u64(nlh, VDPA_ATTR_DEV_FEATURES,
> >>>>>>>>> +                             opts->device_features);
> >>>>>>>>> +     }
> >>>>>>>>>       }
> >>>>>>>>>
> >>>>>>>>>       static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
> >>>>>>>>> @@ -329,6 +346,14 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
> >>>>>>>>>
> >>>>>>>>>                           NEXT_ARG_FWD();
> >>>>>>>>>                           o_found |= VDPA_OPT_QUEUE_INDEX;
> >>>>>>>>> +             } else if (!strcmp(*argv, "device_features") &&
> >>>>>>>>> +                        (o_optional & VDPA_OPT_VDEV_FEATURES)) {
> >>>>>>>>> +                     NEXT_ARG_FWD();
> >>>>>>>>> +                     err = vdpa_argv_u64_hex(vdpa, argc, argv,
> >>>>>>>>> +                                             &opts->device_features);
> >>>>>>>>> +                     if (err)
> >>>>>>>>> +                             return err;
> >>>>>>>>> +                     o_found |= VDPA_OPT_VDEV_FEATURES;
> >>>>>>>>>                   } else {
> >>>>>>>>>                           fprintf(stderr, "Unknown option \"%s\"\n", *argv);
> >>>>>>>>>                           return -EINVAL;
> >>>>>>>>> @@ -615,8 +640,9 @@ static int cmd_mgmtdev(struct vdpa *vdpa, int argc, char **argv)
> >>>>>>>>>       static void cmd_dev_help(void)
> >>>>>>>>>       {
> >>>>>>>>>           fprintf(stderr, "Usage: vdpa dev show [ DEV ]\n");
> >>>>>>>>> -     fprintf(stderr, "       vdpa dev add name NAME mgmtdev MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ]\n");
> >>>>>>>>> -     fprintf(stderr, "                                                    [ max_vqp MAX_VQ_PAIRS ]\n");
> >>>>>>>>> +     fprintf(stderr, "       vdpa dev add name NAME mgmtdevMANAGEMENTDEV [ device_features DEVICE_FEATURES]\n");
> >>>>>>>>> +     fprintf(stderr, "                                                   [ mac MACADDR ] [ mtu MTU ]\n");
> >>>>>>>>> +     fprintf(stderr, "                                                   [ max_vqp MAX_VQ_PAIRS ]\n");
> >>>>>>>>>           fprintf(stderr, "       vdpa dev del DEV\n");
> >>>>>>>>>           fprintf(stderr, "Usage: vdpa dev config COMMAND [ OPTIONS ]\n");
> >>>>>>>>>           fprintf(stderr, "Usage: vdpa dev vstats COMMAND\n");
> >>>>>>>>> @@ -708,7 +734,7 @@ static int cmd_dev_add(struct vdpa *vdpa, int argc, char **argv)
> >>>>>>>>>           err = vdpa_argv_parse_put(nlh, vdpa, argc, argv,
> >>>>>>>>>                                     VDPA_OPT_VDEV_MGMTDEV_HANDLE | VDPA_OPT_VDEV_NAME,
> >>>>>>>>>                                     VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU |
> >>>>>>>>> -                               VDPA_OPT_MAX_VQP);
> >>>>>>>>> +                               VDPA_OPT_MAX_VQP | VDPA_OPT_VDEV_FEATURES);
> >>>>>>>>>           if (err)
> >>>>>>>>>                   return err;
> >>>>>>>>>
>

