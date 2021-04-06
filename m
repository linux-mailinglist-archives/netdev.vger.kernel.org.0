Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A076C354F6B
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 11:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244769AbhDFJHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 05:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233581AbhDFJHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 05:07:41 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8A4C06174A
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 02:07:33 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id f16so15633963ljm.1
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 02:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=55VWKKQ7vLzvbshjSiRHs3/wzxC9LdbwbFJFuPk7kA0=;
        b=WNAYogfYN19ue2p9hae/KtPq1bz4RVDQr9lKCAQfxXUBW94p9faBWT+H/h7JLkaDNv
         S8GdoI6NU8IKWiQYubjwvwn56Kx+DD7LHqM9/uSy7w2Or/Vrz8cm0rdUakOzMef86vbR
         c9q4+i21klcm3NaiY9H8eKu7Sci6BNspCSlDBoJcCgqkTTDpMBJy4BL2ttgsOhMtOwWt
         Q2sNr35aTE3JMz1wFMDBYQbx5BFXe1Rong8XL0VAzPlq7/cGr0LfaupPyC/FFN1yA8Um
         fvHEor2kihCphnWzPCup/PlEtKPjpl+9UTfNsV9U/yo4x8GnPa/dJnv1H57jKC4O2EIz
         hrNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=55VWKKQ7vLzvbshjSiRHs3/wzxC9LdbwbFJFuPk7kA0=;
        b=Pc1QfZXX9K607Hd3mMKKhdVsqAbfV0KWdIHz01mKGi2vJl5I8aIkdzbEj08crDK0H/
         FmGUTKWjgW4fis75qyZe1F7bi9rSypnki8gUuZMr4Gi4yP2uJGTz/oyZJdDxZA9vnzg/
         nxy25iKiAi+vrnS6CBMxcydz0EW7d4WaqsZCKIY0gzX7xtygNe7OV9BbIJvPp+oqZ7oc
         6GetbXpr3orH1AJZDv1kmfnNKS6NzoZfukG4ln78zaYWsKhPlKr8dHaBnNgbUM4Efc3l
         P2zRjjUhyXW7eXTO6+rUcUcW7f/Z5wiZwKY9tA+3t+Ss6qqc7ceNeOjZfszhkKBYI8sy
         u0rw==
X-Gm-Message-State: AOAM530kyJsvKsC9KI/PBfKZkjJERRWNBglZjttTZ4oLoPcWq0vmg+ua
        BpribOrcxGZYIPapvVdecd2MWA==
X-Google-Smtp-Source: ABdhPJxUS1FM7zf8GhXW72jNmJAjXACJuCfmN3H+BeYtdBLeUthe42Tr5QUmaIflwkKFWsVQ9GQHqA==
X-Received: by 2002:a2e:8984:: with SMTP id c4mr17909998lji.456.1617700052191;
        Tue, 06 Apr 2021 02:07:32 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id z9sm2151199lji.139.2021.04.06.02.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 02:07:31 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net: dsa: mv88e6xxx: Allow dynamic reconfiguration of tag protocol
In-Reply-To: <YGCfvDhRFcfESYKx@lunn.ch>
References: <20210326105648.2492411-1-tobias@waldekranz.com> <20210326105648.2492411-2-tobias@waldekranz.com> <YGCfvDhRFcfESYKx@lunn.ch>
Date:   Tue, 06 Apr 2021 11:07:30 +0200
Message-ID: <87eefnlr1p.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 28, 2021 at 17:24, Andrew Lunn <andrew@lunn.ch> wrote:
> On Fri, Mar 26, 2021 at 11:56:46AM +0100, Tobias Waldekranz wrote:
>> All devices are capable of using regular DSA tags. Support for
>> Ethertyped DSA tags sort into three categories:
>> 
>> 1. No support. Older chips fall into this category.
>> 
>> 2. Full support. Datasheet explicitly supports configuring the CPU
>>    port to receive FORWARDs with a DSA tag.
>> 
>> 3. Undocumented support. Datasheet lists the configuration from
>>    category 2 as "reserved for future use", but does empirically
>>    behave like a category 2 device.
>
>> +static int mv88e6xxx_change_tag_protocol(struct dsa_switch *ds, int port,
>> +					 enum dsa_tag_protocol proto)
>> +{
>> +	struct mv88e6xxx_chip *chip = ds->priv;
>> +	enum dsa_tag_protocol old_protocol;
>> +	int err;
>> +
>> +	switch (proto) {
>> +	case DSA_TAG_PROTO_EDSA:
>> +		if (chip->info->tag_protocol != DSA_TAG_PROTO_EDSA)
>> +			dev_warn(chip->dev, "Relying on undocumented EDSA tagging behavior\n");
>> +
>> +		break;
>> +	case DSA_TAG_PROTO_DSA:
>> +		break;
>> +	default:
>> +		return -EPROTONOSUPPORT;
>> +	}
>
> You are handling cases 2 and 3 here, but not 1. Which makes it a bit
> of a foot cannon for older devices.
>
> Now that we have chip->tag_protocol, maybe we should change
> chip->info->tag_protocol to mean supported protocols?
>
> BIT(0) DSA
> BIT(1) EDSA
> BIT(2) Undocumented EDSA

Since DSA is supported on all devices, perhaps we should just have:

enum mv88e6xxx_edsa_support {
     MV88E6XXX_EDSA_UNSUPPORTED,
     MV88E6XXX_EDSA_UNDOCUMENTED,
     MV88E6XXX_EDSA_SUPPORTED,
};

?

Do we also want to default to DSA on all devices unless there is a
DT-property saying something else? Using EDSA does not really give you
anything over bare tags anymore. You have fixed the tcpdump-issue, and
the tagger drivers have been unified so there should be no risk of any
regressions there either.
