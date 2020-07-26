Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5E322DCE4
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 09:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgGZHQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 03:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgGZHQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 03:16:09 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4422C0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 00:16:08 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id f18so2612927wmc.0
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 00:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iUqtgzYc55uvFzoXP8Wk8BwclSfU+iC89HxNfrw+JDA=;
        b=UunxAKJJqeVE/CS/mGSSJvnrkwszr6wi60GNpisaC0Sl8x0XM5A5cgZX2/LKeWKFO+
         ICIeQpZcWjhj85rIyCCwmQSJ46QC0Qk5GRZiUhE7z9pdZkrR/4mNuU7Pal/vSImRO9Or
         13cN235FgD/nEscTYURtjmwukYNOHgJ856wi2IVjuI4KC2bY/r55L0weh3kd0ynPvDR/
         5RCgR5EoHIrsHOTfAxXqOKgDF1ai1BB3HlFOJc7TGbjnNWb9hcy4mGcWKpqrpitklwQC
         xy/Q3IPidxKTz9Ilg5Z9YhmL9X7qno5Y050XBJPP+EvT3urao0wvX+ZfkSK8K5jScL2Q
         fmmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iUqtgzYc55uvFzoXP8Wk8BwclSfU+iC89HxNfrw+JDA=;
        b=tXTiF1A7zqHehOR8jNhpLAVz0MZPFaZlvp6PqJce8JgEpPqH0UbexON3wjKtu5r4b0
         hbjWV9o5CurNIrHCFSnAX0AGA5td2UVFbknDZvXatQsFN1+kWzrYUENDLDFIG1UtXGWF
         mZ70F1cx9kbAGbxBB9vypFQi31gElih5WwYUPLDQySLQsL91+4cw60paJCyK9O6E5TVv
         K77EZl1vJdzkWQr8tOUZoboZh/utM0aV8kAvlcdodgc7drielWzPFSeYhmMFhyTJm9tM
         XgbPG10i6NWagTa/SygehIImY44mT9/e9wFH8p2SQkECnhEVKhH3h2lvCo7WfrvUPXNx
         PO1A==
X-Gm-Message-State: AOAM531cSEslr/MVBx43ZWz5K3A9GZGIU2VFH5IkQAjTkYIUuUOrhER0
        cJJzGfz6wOgYQs32UGZStCnWUQ==
X-Google-Smtp-Source: ABdhPJxWTW0qrCJTXhu3EkNq7h52nRUSLv4+e/VpUjgKa34i49Z1eZ2iUO7v5+9fizsL0t8L4H4irA==
X-Received: by 2002:a1c:19c6:: with SMTP id 189mr7599683wmz.98.1595747767347;
        Sun, 26 Jul 2020 00:16:07 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id u20sm13224154wmc.42.2020.07.26.00.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2020 00:16:06 -0700 (PDT)
Date:   Sun, 26 Jul 2020 09:16:06 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Jakub Kicinski <kubakici@wp.pl>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tom Herbert <tom@herbertland.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: Re: [RFC PATCH net-next v2 6/6] devlink: add overwrite mode to flash
 update
Message-ID: <20200726071606.GB2216@nanopsycho>
References: <20200717183541.797878-1-jacob.e.keller@intel.com>
 <20200717183541.797878-7-jacob.e.keller@intel.com>
 <20200720100953.GB2235@nanopsycho>
 <20200720085159.57479106@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200721135356.GB2205@nanopsycho>
 <20200721100406.67c17ce9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200722105139.GA3154@nanopsycho>
 <02874ECE860811409154E81DA85FBB58C8AF3382@fmsmsx101.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02874ECE860811409154E81DA85FBB58C8AF3382@fmsmsx101.amr.corp.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 22, 2020 at 05:30:05PM CEST, jacob.e.keller@intel.com wrote:
>
>
>> -----Original Message-----
>> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
>> Behalf Of Jiri Pirko
>> Sent: Wednesday, July 22, 2020 3:52 AM
>> To: Jakub Kicinski <kubakici@wp.pl>
>> Cc: Keller, Jacob E <jacob.e.keller@intel.com>; netdev@vger.kernel.org; Tom
>> Herbert <tom@herbertland.com>; Jiri Pirko <jiri@mellanox.com>; Jakub Kicinski
>> <kuba@kernel.org>; Jonathan Corbet <corbet@lwn.net>; Michael Chan
>> <michael.chan@broadcom.com>; Bin Luo <luobin9@huawei.com>; Saeed
>> Mahameed <saeedm@mellanox.com>; Leon Romanovsky <leon@kernel.org>;
>> Ido Schimmel <idosch@mellanox.com>; Danielle Ratson
>> <danieller@mellanox.com>
>> Subject: Re: [RFC PATCH net-next v2 6/6] devlink: add overwrite mode to flash
>> update
>> 
>> Tue, Jul 21, 2020 at 07:04:06PM CEST, kubakici@wp.pl wrote:
>> >On Tue, 21 Jul 2020 15:53:56 +0200 Jiri Pirko wrote:
>> >> Mon, Jul 20, 2020 at 05:51:59PM CEST, kubakici@wp.pl wrote:
>> >> >On Mon, 20 Jul 2020 12:09:53 +0200 Jiri Pirko wrote:
>> >> >> This looks odd. You have a single image yet you somehow divide it
>> >> >> into "program" and "config" areas. We already have infra in place to
>> >> >> take care of this. See DEVLINK_ATTR_FLASH_UPDATE_COMPONENT.
>> >> >> You should have 2 components:
>> >> >> 1) "program"
>> >> >> 2) "config"
>> >> >>
>> >> >> Then it is up to the user what he decides to flash.
>> >> >
>> >> >99.9% of the time users want to flash "all". To achieve "don't flash
>> >> >config" with current infra users would have to flash each component
>> >>
>> >> Well you can have multiple component what would overlap:
>> >> 1) "program" + "config" (default)
>> >> 2) "program"
>> >> 3) "config"
>> >
>> >Say I have FW component and UNDI driver. Now I'll have 4 components?
>> >fw.prog, fw.config, undi.prog etc? Are those extra ones visible or just
>> 
>> Visible in which sense? We don't show components anywhere if I'm not
>> mistaken. They are currently very rarely used. Basically we just ported
>> it from ethtool without much thinking.
>> 
>
>Component names are used in devlink info and displayed to end users along with versions, plus they're names passed by the user in devlink flash update. As far as documented, we shouldn't add new components without associated versions in the info report.

Okay. So it is loosely coupled. I think it would be nice to tight those
2 togeter so it is not up to the driver how he decides to implement it.

>
>> 
>> >"implied"? If they are visible what version does the config have?
>> 
>> Good question. we don't have per-component version so far. I think it
>> would be good to have it alonside with the listing.
>> 
>> 
>> >
>> >Also (3) - flashing config from one firmware version and program from
>> >another - makes a very limited amount of sense to me.
>> >
>> >> >one by one and then omit the one(s) which is config (guessing which
>> >> >one that is based on the name).
>> >> >
>> >> >Wouldn't this be quite inconvenient?
>> >>
>> >> I see it as an extra knob that is actually somehow provides degradation
>> >> of components.
>> >
>> >Hm. We have the exact opposite view on the matter. To me components
>> >currently correspond to separate fw/hw entities, that's a very clear
>> >meaning. PHY firmware, management FW, UNDI. Now we would add a
>> >completely orthogonal meaning to the same API.
>> 
>> I understand. My concern is, we would have a component with some
>> "subparts". Now it is some fuzzy vagely defined "config part",
>> in the future it might be something else. That is what I'm concerned
>> about. Components have clear api.
>> 
>> So perhaps we can introduce something like "component mask", which would
>> allow to flash only part of the component. That is basically what Jacob
>> has, I would just like to have it well defined.
>> 
>> 
>
>So, we could make this selection a series of masked bits instead of a single enumeration value.

Yeah.
