Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6F9912232A
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 05:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfLQEeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 23:34:37 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:45733 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbfLQEeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 23:34:37 -0500
Received: by mail-pj1-f66.google.com with SMTP id r11so3966676pjp.12;
        Mon, 16 Dec 2019 20:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SiFiK7c2d8r6lgLYh8nZc/9629Qds+CaxVjqD8rqfFA=;
        b=fum8bykTd47TC/bJnMKu7QGQ909Rsq07l0RWAcRTzA+wlToPMjsGUAgzlI/0rWB1wB
         aFeUUVlMQNIoTF/3gq69UUR/POEKSBwuHvn41TWtrWasSZvZ7F00R0ybsAFqsK6QX3v6
         JJYC0UfmiMz9U6LwvNU9AN43RLDvxZxMZc931OJ+GSQPqTljXAL/4J/LoAev7+W+G/1x
         +MgFbql4SEJstHgqBJ/UvzJw5msgoZKIdQ+U4SBSArw0PFd4oITwQZ7cWBS7qOSyNBQQ
         eeoIKCrQvvIfsfyfJe8JmX1vCAtPz23ziP2O5DASVRkcFqR1+oGouvgBX5/DlOEfegPn
         kh5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SiFiK7c2d8r6lgLYh8nZc/9629Qds+CaxVjqD8rqfFA=;
        b=oCWWDg9KFHAszk3s9Naa6LdLIBrU4Wu7AxGsL9XwNnDmgTLraXlfDNEBQX2+ZTI05c
         dBCqjYvxRqRiH4+PWFsdLFGg2kBTFmpQHeAUGoN1N/YT6S2YjBz1PCOlTWH3QjaSscBL
         647vfCxrmKv8Ms3IYhhymRzxIcTC4QRdaFu+jMfczBSd2y53PZnt7fWKIuToHw6MUNr7
         AAy4+oGZzeNozfojur+W6Yh3RDq3pI2kyRJDfMXjR+3sK7ClluPAtgEHiRvnDiSYzwnq
         /2z25sVfVG2VDLKzErtN/VDapD11mdFk8qOq7ouJydQI2zRfcoq53uWqpUa2aaVH7pDk
         Wezg==
X-Gm-Message-State: APjAAAVLEqnCe3wD/3YpnvLaqppnGOOdvn3HaQGYloFiZZIJlW6E45yy
        E83H5+d8nSxIsbF8u1RY1Lw=
X-Google-Smtp-Source: APXvYqwPZ1tC+9cPcEc4YjZI9UA/fSKnNYIVyZM2w9csUWjq7Q1Y4iqgXKALWoq/idjPiQptmhTR3A==
X-Received: by 2002:a17:902:b195:: with SMTP id s21mr20337757plr.265.1576557276358;
        Mon, 16 Dec 2019 20:34:36 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id g22sm24364130pgk.85.2019.12.16.20.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 20:34:35 -0800 (PST)
Date:   Mon, 16 Dec 2019 20:34:33 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        devicetree@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: Re: [PATCH V6 net-next 11/11] ptp: Add a driver for InES time
 stamping IP core.
Message-ID: <20191217043433.GA1363@localhost>
References: <cover.1576511937.git.richardcochran@gmail.com>
 <33afc113fa0b301d289522971c83dbbf0d36c8ba.1576511937.git.richardcochran@gmail.com>
 <20191216161114.3604d45d@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216161114.3604d45d@cakuba.netronome.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 04:11:14PM -0800, Jakub Kicinski wrote:
> On Mon, 16 Dec 2019 08:13:26 -0800, Richard Cochran wrote:
> > +	clkid = (u64 *)(data + offset + OFF_PTP_CLOCK_ID);
> > +	portn = (u16 *)(data + offset + OFF_PTP_PORT_NUM);
> > +	seqid = (u16 *)(data + offset + OFF_PTP_SEQUENCE_ID);
> 
> These should perhaps be __be types?
> 
> Looks like there is a few other sparse warnings in ptp_ines.c, would
> you mind addressing those?

I saw the sparse warnings before (from one of the robots), but I
decided that they are false positives.  Or perhaps I don't appreciate
what the warnings mean...

Take the 'clkid' pointer for example:
 
> > +	if (cpu_to_be64(ts->clkid) != *clkid) {
> > +		pr_debug("clkid mismatch ts %llx != skb %llx\n",
> > +			 cpu_to_be64(ts->clkid), *clkid);
> > +		return false;
> > +	}

The field that to which 'clkid' points is in network byte order.  The
code correctly converts ts->clkid (in CPU byte order) to network byte
order before comparing it with the field.

So where is the error?

Thanks,
Richard
