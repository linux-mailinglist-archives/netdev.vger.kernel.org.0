Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3E954D8FB
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 05:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350511AbiFPDlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 23:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349629AbiFPDl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 23:41:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933FC286D5
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 20:41:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9C839CE1CF1
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 03:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD2FC34114;
        Thu, 16 Jun 2022 03:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655350880;
        bh=EYtj5S24r7MMB8N8J5q/zcRIxDfFnpzxEIXzj/ynlSk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TmiCWMvFv2jnIWTr+Co1rL/Ip0QACchHLeiDUhXbBCAYiBKuuK9xKMjzYPQiji1j8
         NP0mDi4lU6mGfXwe2/zuzDb2Wzzhl2dveprFrRbb9PUM00vu8YdH+/JKbQzljjJrJT
         Ux4N4n5C8fNNOf87dsmG3hcitm7F303JVVi3PJfsAc/X9z1b8FlUSCMWC31eFS69w2
         pY78oGPEqEWURYbGs51Lb85ltWYIXqLHo3AxAUtWUPkhcSF53/KHMQvyaZ8cxiyemz
         A3u1TUaFsrcGFJ6QfqOzHuaqr5D1eez9gaAW90ZIJdOoqfHeI37shHARcgvMCJeBVa
         oH1j5zz5gzu5A==
Date:   Wed, 15 Jun 2022 20:41:18 -0700
From:   Eduardo Valentin <evalenti@kernel.org>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     Vadim Pasternak <vadimp@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "edubezval@gmail.com" <edubezval@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [EXTERNAL][patch net-next RFC v1] mlxsw: core: Add the hottest
 thermal zone detection
Message-ID: <20220616034118.GA23410@uf8f119305bce5e.ant.amazon.com>
References: <20190529135223.5338-1-vadimp@mellanox.com>
 <f3c62ebe-7d59-c537-a010-bff366c8aeba@linaro.org>
 <BN9PR12MB53814C07F1FF66C06BCDC5FAAFAD9@BN9PR12MB5381.namprd12.prod.outlook.com>
 <7cfa0391-798e-3993-5fa7-a8b31bcef534@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7cfa0391-798e-3993-5fa7-a8b31bcef534@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey guys,

On Thu, Jun 16, 2022 at 12:27:39AM +0200, Daniel Lezcano wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> Hi Vadim,
> 
> On 16/06/2022 00:06, Vadim Pasternak wrote:
> > Hi Daniel,
> > 
> > > -----Original Message-----
> > > From: Daniel Lezcano <daniel.lezcano@linaro.org>
> > > Sent: Wednesday, June 15, 2022 11:32 PM
> > > To: Vadim Pasternak <vadimp@nvidia.com>; davem@davemloft.net
> > > Cc: netdev@vger.kernel.org; linux@roeck-us.net; rui.zhang@intel.com;
> > > edubezval@gmail.com; jiri@resnulli.us; Ido Schimmel <idosch@nvidia.com>
> > > Subject: Re: [patch net-next RFC v1] mlxsw: core: Add the hottest thermal
> > > zone detection
> > > 
> > > 
> > > Hi Vadim,
> > > 
> > > On 29/05/2019 15:52, Vadim Pasternak wrote:
> > > > When multiple sensors are mapped to the same cooling device, the
> > > > cooling device should be set according the worst sensor from the
> > > > sensors associated with this cooling device.
> > > > 
> > > > Provide the hottest thermal zone detection and enforce cooling device
> > > > to follow the temperature trends the hottest zone only.
> > > > Prevent competition for the cooling device control from others zones,
> > > > by "stable trend" indication. A cooling device will not perform any
> > > > actions associated with a zone with "stable trend".
> > > > 
> > > > When other thermal zone is detected as a hottest, a cooling device is
> > > > to be switched to following temperature trends of new hottest zone.
> > > > 
> > > > Thermal zone score is represented by 32 bits unsigned integer and
> > > > calculated according to the next formula:
> > > > For T < TZ<t><i>, where t from {normal trip = 0, high trip = 1, hot
> > > > trip = 2, critical = 3}:
> > > > TZ<i> score = (T + (TZ<t><i> - T) / 2) / (TZ<t><i> - T) * 256 ** j;
> > > > Highest thermal zone score s is set as MAX(TZ<i>score); Following this
> > > > formula, if TZ<i> is in trip point higher than TZ<k>, the higher score
> > > > is to be always assigned to TZ<i>.
> > > > 
> > > > For two thermal zones located at the same kind of trip point, the
> > > > higher score will be assigned to the zone, which closer to the next trip
> > > point.
> > > > Thus, the highest score will always be assigned objectively to the
> > > > hottest thermal zone.
> > > 
> > > While reading the code I noticed this change and I was wondering why it was
> > > needed.
> > > 
> > > The thermal framework does already aggregates the mitigation decisions,
> > > taking the highest cooling state [1].
> > > 
> > > That allows for instance a spanning fan on a dual socket. Two thermal zones
> > > for one cooling device.
> > 
> > Here the hottest thermal zone is calculated for different thermal zone_devices, for example, each
> > optical transceiver or gearbox is separated 'tzdev', while all of them share the same cooling device.
> > It could up to 128 transceivers.
> > 
> > It was also intention to avoid a competition between thermal zones when some of them
> > can be in trend up state and some  in trend down.
> > 
> > Are you saying that the below code will work for such case?
> > 
> >       /* Make sure cdev enters the deepest cooling state */
> >       list_for_each_entry(instance, &cdev->thermal_instances, cdev_node) {
> >               dev_dbg(&cdev->device, "zone%d->target=%lu\n",
> >                       instance->tz->id, instance->target);
> >               if (instance->target == THERMAL_NO_TARGET)
> >                       continue;
> >               if (instance->target > target)
> >                       target = instance->target;
> >       }
> 
> Yes, that is my understanding.
> 
> For the thermal zones which are under the temperature limit, their
> instance->target will be THERMAL_NO_TARGET and will be discarded by this
> loop.
> 
> For the ones being mitigated, the highest cooling state will be used.
> 
> The purpose of this loop is exactly for your use case. If it happens it
> does not work as expected, then it is something in the core code to be
> fixed.
> 
> 
> > > AFAICS, the code hijacked the get_trend function just for the sake of
> > > returning 1 for the hotter thermal zone leading to a computation of the trend
> > > in the thermal core code.
> > 
> > Yes, get_trend() returns one just to indicate that cooling device should not be
> > touched for a thermal zone, which is not hottest.
> > 
> > > 
> > > I would like to get rid of the get_trend ops in the thermal framework and the
> > > changes in this patch sounds like pointless as the aggregation of the cooling
> > > action is already handled in the thermal framework.
> > > 
> > > Given the above, it would make sense to revert commit 6f73862fabd93 and
> > > 2dc2f760052da ?
> > 
> > I believe we should run thermal emulation to validate we are OK.

I agree with the suggestion that these commit shall be considered for revert. 

The thermal core will do aggregation while handling cooling devices
to set the cooling state to whatever is currently the one requiring more impact
on temperature.

And, yes, please check with thermal emulation.

Side note, please use my evalenti@kernel.org address if you need my attention.
I will keep on monitoring messages sent to that address.

I will be updating my contacts at MAINTAINERS soon.
> 
> Sure, let me know
> 
> Thanks
> 
>   -- Daniel
> 
> > 
> > Thanks,
> > Vadim.
> > 
> > > 
> > > Thanks
> > > 
> > >     -- Daniel
> > > 
> > > [1]
> > > https://git.kernel.org/pub/scm/linux/kernel/git/thermal/linux.git/tree/drive
> > > rs/thermal/thermal_helpers.c#n190
> > > 
> > > 
> > > [ ... ]
> > > 
> > > 
> > > --
> > > <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs
> > > 
> > > Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> > > <http://twitter.com/#!/linaroorg> Twitter |
> > > <http://www.linaro.org/linaro-blog/> Blog
> 
> 
> --
> <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs
> 
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog

-- 
All the best,
Eduardo Valentin
