Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2404A66F2
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 22:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbiBAVWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 16:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiBAVWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 16:22:17 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5C1C06173D
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 13:22:16 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id c7so25458688ljr.13
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 13:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=Oex2OjPBU+g23gPxYBdZdkU42gjulLum1J0L/GI9cY4=;
        b=6JdyE30eEKA6UHiPWDRKnjIzt/wtfLfJRqA2WjKgBix9sry7OHqv9SxQedYjfhFQBx
         KnqnmBQ4UUKSZl/dMHPWb6+bnTW35k6v5VJ+9zzzMw4S/NbmpRbiKPmCriF7j7zVovxw
         9dtJ1OojCMuER8iKJOsHCvX1kFLtAsW+qmXytGWWhHQRDlMDI/VUDOWQNHIrTTiUDV1D
         CFrO+/9CVl4hzSbdeX0Zw5H7KfYmeeircXkMZ3+QWbZWW3uoa2PzNgkizD5bPSTN2AA8
         i+IN9Sf6WoQmx8OTt+R9TIRii1C/KqvblK13+jsOW7uCPyDeIYhGHq0izSSbb6HJpSUG
         uYyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Oex2OjPBU+g23gPxYBdZdkU42gjulLum1J0L/GI9cY4=;
        b=C07L75768DHb/eH46S7fEaQuSUOxDBVqV2eSNSWHGCewzfY6mi+h/Cy05uCyKgUuZc
         mDvWIEtSiZg37gJgG56PlJw3ZCO8xnHGd1CSfdsCAsDWecLmyFnulxst+HzCAtmOE/w1
         YjlN9R3hcZE7sKCE6ZaaahQUeyBan1ZLoZ227bdR2TeKfLNoiyhADQgOk7hxC807llj/
         iViTjpR+JcNaKQLp9K315bCpgx53dJzHqRyS2cgKp7lWbzVsv9WRZ9bqUFxWq4GcmGmc
         c8idNSqv9dBRUm3DdfbIAnzOluDFoWrYMo0wIiwHtfPd1cd6XE9+EZFmyHDMbvIqRKG0
         iL6Q==
X-Gm-Message-State: AOAM530P55kDtE9m2/kB4PDv77j6lD5NrXaphNci5oahs91f+A+Q0ZMB
        95RAbPMTa7mI5vZOUUWcazsiXg==
X-Google-Smtp-Source: ABdhPJyG6jq7qJyaC+wEFwkYxWs0qiy+j0QgMe8Cvr/4LBdwGfSGOvUJhDKsXpFtt2Xl0k1XzEHbDw==
X-Received: by 2002:a2e:bc26:: with SMTP id b38mr17733313ljf.54.1643750534794;
        Tue, 01 Feb 2022 13:22:14 -0800 (PST)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id v3sm2960507lfi.114.2022.02.01.13.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 13:22:14 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] net: dsa: mv88e6xxx: Improve isolation of
 standalone ports
In-Reply-To: <20220201201141.u3qhhq75bo3xmpiq@skbuf>
References: <20220131154655.1614770-1-tobias@waldekranz.com>
 <20220131154655.1614770-2-tobias@waldekranz.com>
 <20220201170634.wnxy3s7f6jnmt737@skbuf> <87a6fabbtb.fsf@waldekranz.com>
 <20220201201141.u3qhhq75bo3xmpiq@skbuf>
Date:   Tue, 01 Feb 2022 22:22:13 +0100
Message-ID: <8735l2b7ui.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 22:11, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Tue, Feb 01, 2022 at 08:56:32PM +0100, Tobias Waldekranz wrote:
>> >> - sw0p1 and sw1p1 are bridged
>> >
>> > Do sw0p1 and sw1p1 even matter?
>> 
>> Strictly speaking, no - it was just to illustrate...
>> 
>> >> - sw0p2 and sw1p2 are in standalone mode
>> >> - Learning must be enabled on sw0p3 in order for hardware forwarding
>> >>   to work properly between bridged ports
>> 
>> ... this point, i.e. a clear example of why learning can't be disabled
>> on DSA ports.
>
> Ok, I understand now. It wasn't too clear.
>
>> >> 1. A packet with SA :aa comes in on sw1p2
>> >>    1a. Egresses sw1p0
>> >>    1b. Ingresses sw0p3, ATU adds an entry for :aa towards port 3
>> >>    1c. Egresses sw0p0
>> >> 
>> >> 2. A packet with DA :aa comes in on sw0p2
>> >>    2a. If an ATU lookup is done at this point, the packet will be
>> >>        incorrectly forwarded towards sw0p3. With this change in place,
>> >>        the ATU is pypassed and the packet is forwarded in accordance
>> >
>> > s/pypassed/bypassed/
>> >
>> >>        whith the PVT, which only contains the CPU port.
>> >
>> > s/whith/with/
>> >
>> > What you describe is a bit convoluted, so let me try to rephrase it.
>> > The mv88e6xxx driver configures all standalone ports to use the same
>> > DefaultVID(0)/FID(0), and configures standalone user ports with no
>> > learning via the Port Association Vector. Shared (cascade + CPU) ports
>> > have learning enabled so that cross-chip bridging works without floods.
>> > But since learning is per port and not per FID, it means that we enable
>> > learning in FID 0, the one where the ATU was supposed to be always empty.
>> > So we may end up taking wrong forwarding decisions for standalone ports,
>> > notably when we should do software forwarding between ports of different
>> > switches. By clearing MapDA, we force standalone ports to bypass any ATU
>> > entries that might exist.
>> 
>> Are you saying you want me to replace the initial paragraph with your
>> version, or are you saying the the example is convoluted and should be
>> replaced by this text? Or is it only for the benefit of other readers?
>
> Just for the sake of discussion, I wanted to make sure I understand what
> you describe.
>
>> > Question: can we disable learning per FID? I searched for this in the
>> > limited documentation that I have, but I didn't see such option.
>> > Doing this would be advantageous because we'd end up with a bit more
>> > space in the ATU. With your solution we're just doing damage control.
>> 
>> As you discovered, and as I tried to lay out in the cover, this is only
>> one part of the whole solution.
>
> I'm not copied to the cover letter :) and I have some issues with my
> email client / vger, where emails that I receive through the mailing list
> sometimes take days to reach my inbox, whereas emails sent directly to
> me reach my inbox instantaneously. So don't assume I read email that
> wasn't targeted directly to me, sorry.

No worries. I have recently started using get_maintainers.pl to auto
generate the recipient list, with the result that the cover is only sent
to the list. Ideally I would like send-email to use the union of all
recipients for the cover letter, but I haven't figured that one out yet.

I actually gave up on getting my mailinglists from my email provider,
now I just download it directly from lore. I hacked together a script
that will scrape a public-inbox repo and convert it to a Maildir:

https://github.com/wkz/notmuch-lore

As you can tell from the name, it is tailored for plugging into notmuch,
but the guts are pretty generic.

>> >> diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
>> >> index 03382b66f800..5c347cc58baf 100644
>> >> --- a/drivers/net/dsa/mv88e6xxx/port.h
>> >> +++ b/drivers/net/dsa/mv88e6xxx/port.h
>> >> @@ -425,7 +425,7 @@ int mv88e6185_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cmode);
>> >>  int mv88e6352_port_get_cmode(struct mv88e6xxx_chip *chip, int port, u8 *cmode);
>> >>  int mv88e6xxx_port_drop_untagged(struct mv88e6xxx_chip *chip, int port,
>> >>  				 bool drop_untagged);
>> >> -int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port);
>> >> +int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port, bool map);
>> >>  int mv88e6095_port_set_upstream_port(struct mv88e6xxx_chip *chip, int port,
>> >>  				     int upstream_port);
>> >>  int mv88e6xxx_port_set_mirror(struct mv88e6xxx_chip *chip, int port,
>> >> diff --git a/include/net/dsa.h b/include/net/dsa.h
>> >> index 57b3e4e7413b..30f3192616e5 100644
>> >> --- a/include/net/dsa.h
>> >> +++ b/include/net/dsa.h
>> >> @@ -581,6 +581,18 @@ static inline bool dsa_is_upstream_port(struct dsa_switch *ds, int port)
>> >>  	return port == dsa_upstream_port(ds, port);
>> >>  }
>> >>  
>> >> +/* Return the local port used to reach the CPU port */
>> >> +static inline unsigned int dsa_switch_upstream_port(struct dsa_switch *ds)
>> >> +{
>> >> +	int p;
>> >> +
>> >> +	for (p = 0; p < ds->num_ports; p++)
>> >> +		if (!dsa_is_unused_port(ds, p))
>> >> +			return dsa_upstream_port(ds, p);
>> >
>> > dsa_switch_for_each_available_port
>> >
>> > Although to be honest, the caller already has a dp, I wonder why you
>> > need to complicate things and don't just call dsa_upstream_port(ds,
>> > dp->index) directly.
>> 
>> Because dp refers to the port we are determining the permissions _for_,
>> and ds refers to the chip we are configuring the PVT _on_.
>> 
>> I think other_dp and dp should swap names with each other. Because it is
>> very easy to get confused. Or maybe s/dp/remote_dp/ and s/other_dp/dp/?
>
> Sorry, my mistake, I was looking at the patch in the email client and
> didn't recognize from the context that this is mv88e6xxx_port_vlan(),
> and that the port is remote. So I retract the part about calling
> dsa_upstream_port() directly, but please still consider using a more
> appropriate port iterator for the implementation of dsa_switch_upstream_port().

Will do!
