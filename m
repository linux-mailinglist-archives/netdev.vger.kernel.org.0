Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0031F33ED3D
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 10:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbhCQJlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 05:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbhCQJlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 05:41:47 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11855C06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 02:41:47 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id z25so2323338lja.3
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 02:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=l5YmVFHIXVLGMRRUQh16y42bh72LqTU0gOJ2Nw2akbA=;
        b=I1J28xnsrR09698UkzntFxznD+gwwtKNBtDGcy/BNpA2ZY5/6p0cmk8pBPXTw/SI/i
         Ek+STfug9wWGIFBOV33xWPn2yzXSOEg/Gf0x+ZUzxDDAV+eGGmnJAWuHAJjc1/eN/yB1
         wlVOKXzRs3xrmsJTi6o/Y5kqEpOJgwulWbQc/wjg4RDPWJc2YJUbtdRfLkW7IxGoM/u1
         S7VPQ7Bj3bs0LS34tUt6Uo62BTfOcPbB1op/m2I1Ejucc3YPaRvybfwa3s6y5o59l/Tm
         eqPt5MKw7GYY95Es8+y+qkYoV3xjqmBuhnt/wnCsuuegcgMaeNH5U/D4Kcg6XI8zvGvr
         +jew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=l5YmVFHIXVLGMRRUQh16y42bh72LqTU0gOJ2Nw2akbA=;
        b=I5DbExxKlJdUSrDf6iKu4FVJD7A1UeWY2gc5NqygH3MqtFmkoUf2v36gPCZjE+I5yP
         4whKfMeACfXc35KDc985U50JjcQ553oZuQCQfntlsr18MgapPuxDgSrB8+IzI6r0dOMz
         fA/W/kT24EZzl+OQobWbTHxLZOyzNJAGU1kBehq30GoaXtbejYJjGujGJMe4iYFLu6j/
         8Hcf7s5O/DTfCQ8TwU+ynwGU6BTLXWjVZfSh1zYScZF5QuBsVEI27DF9BQXbqoWMg8/D
         Wxeu5arPVErzKtgr+INxP1CXZ6ac+jemvE0IQRYO9kVgxa7U9X+FLhgYlYJgcwZ4R7Iq
         wD2A==
X-Gm-Message-State: AOAM5321GMfNBNoKYrvZjL4LHHpGobOVq8TTk5r/XRNiftP2PdvwEd2g
        oWEj0iwVs2tZxja/ykwQOYov0Rb3supCQi5U
X-Google-Smtp-Source: ABdhPJwK2I9Oo2nzG+pWNadJTRrB/rahdLNL03Td8q7CIemW32m5thOyz4dJrfX8d74GRIY1aHSpLg==
X-Received: by 2002:a2e:9198:: with SMTP id f24mr1818926ljg.32.1615974105189;
        Wed, 17 Mar 2021 02:41:45 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id m7sm3274711lfg.285.2021.03.17.02.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:41:44 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] net: dsa: mv88e6xxx: Provide generic VTU iterator
In-Reply-To: <20210316084237.l6q4p3peonowshds@skbuf>
References: <20210315211400.2805330-1-tobias@waldekranz.com> <20210315211400.2805330-2-tobias@waldekranz.com> <20210316084237.l6q4p3peonowshds@skbuf>
Date:   Wed, 17 Mar 2021 10:41:44 +0100
Message-ID: <87y2emnmlj.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 10:42, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Mon, Mar 15, 2021 at 10:13:56PM +0100, Tobias Waldekranz wrote:
>> @@ -2184,25 +2230,7 @@ static int mv88e6xxx_port_db_dump(struct mv88e6xxx_chip *chip, int port,
>>  	if (err)
>>  		return err;
>>  
>> -	/* Dump VLANs' Filtering Information Databases */
>> -	vlan.vid = mv88e6xxx_max_vid(chip);
>> -	vlan.valid = false;
>> -
>> -	do {
>> -		err = mv88e6xxx_vtu_getnext(chip, &vlan);
>> -		if (err)
>> -			return err;
>> -
>> -		if (!vlan.valid)
>> -			break;
>> -
>> -		err = mv88e6xxx_port_db_dump_fid(chip, vlan.fid, vlan.vid, port,
>> -						 cb, data);
>> -		if (err)
>> -			return err;
>> -	} while (vlan.vid < mv88e6xxx_max_vid(chip));
>> -
>> -	return err;
>> +	return mv88e6xxx_vtu_walk(chip, mv88e6xxx_port_db_dump_vlan, &ctx);
>>  }
>
> Can the mv88e6xxx_port_db_dump_fid(VLAN 0) located above this call be
> covered by the same mv88e6xxx_vtu_walk?

The port's default default FID does not belong to any VLAN, so it is
never loaded in the VTU. That is why it handled separately. So, no :)
