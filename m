Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7BC5DF341
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 18:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbfJUQgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 12:36:04 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40185 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfJUQgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 12:36:04 -0400
Received: by mail-wr1-f66.google.com with SMTP id o28so14750894wro.7
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 09:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rYGCs8IbqfDvfK/AYnWCXK3pREg9I+ooMI5SxqO0Eyg=;
        b=0n2gUf9pmDyG6QAMEA95St07Lljjs9IxQhjwo9Nlh+SN2v4e1t2w66r3korhhTrFm+
         alRIMpTV7Tip3yXtYXSZOjmf+jBXDzH7o3+BwSn2w4f7PNUi65nhIxAs7Pu0mwBPqHVU
         asUQ6VB1p32+1OOxeBDjAxMoXVlYl4PlLy/l1uTTkrqp1AJrtm4d1uAgiOW/qwxdGK2A
         Mou+hT3Tr/S2TcOkhe5Wwqc55ehCjJxbk5l5NARohojBU7N0RTKdcco6zAE6qP2Y1X53
         38pv3IL6LSBklLMe89Qh5Qzd4jI9u+YtawHsFGCdY89VMau95Fn4n9PA1ajs0p5yoEN1
         08CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rYGCs8IbqfDvfK/AYnWCXK3pREg9I+ooMI5SxqO0Eyg=;
        b=CmbMSjMjFvHcI8phW6ICaeiIuE8TfofQS8UhcidG0zZTpluvPTkJ1QcGE8o8CIHRc7
         1gAc8GbjG1DeBmSA4DTbfT5jE3muD7aJu/gMgoUC5TGlzHTztAWXunw2CK2H2YcmsqzQ
         jS3eCkUT6JabYyVRTWYne4+JewN2nSTMoP0zeci1p9c63pTVtYT4WX/p+UiBze01QFWW
         AWi7yaYm9uTVr4asfSr1/aluo9UpsEQbUJgCWL0Sd5AHnCJE9gO1b2H0Rf6bmb3yRgxv
         B+T3dazfawO4Ho648/WPlVGXsYHXjMW7WYFnChQfG/MH3j2yD4AiZD2173BU8yvKmnrQ
         xf4w==
X-Gm-Message-State: APjAAAVeRexaVgUqKO+7Qd+/FeHhfshfZnzzpKmawaXWdS4+/mG7n7te
        JZpFUj/NuQQM17Zt6Yja6rcf6iqGqykO2A==
X-Google-Smtp-Source: APXvYqwfh7/R8krc/+gmpaxar+7JO/KA7WMbGZ6G5XEx5VJCflb8JWG0RvDL/JT78BHRpLyN/9A3HA==
X-Received: by 2002:adf:a506:: with SMTP id i6mr20254212wrb.159.1571675762166;
        Mon, 21 Oct 2019 09:36:02 -0700 (PDT)
Received: from netronome.com ([83.137.2.245])
        by smtp.gmail.com with ESMTPSA id w9sm8588042wrt.85.2019.10.21.09.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 09:36:01 -0700 (PDT)
Date:   Mon, 21 Oct 2019 18:35:53 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linville@tuxdriver.com, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: Re: [PATCH 1/3] ethtool: correctly interpret bitrate of 255
Message-ID: <20191021163551.GA7530@netronome.com>
References: <E1iLYu1-0000sp-W5@rmk-PC.armlinux.org.uk>
 <20191021074030.GB4486@netronome.com>
 <20191021080944.GL25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021080944.GL25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 09:09:44AM +0100, Russell King - ARM Linux admin wrote:
> On Mon, Oct 21, 2019 at 09:40:31AM +0200, Simon Horman wrote:
> > On Fri, Oct 18, 2019 at 09:31:13PM +0100, Russell King wrote:
> > > From: Russell King <rmk+kernel@armlinux.org.uk>
> > > 
> > > A bitrate of 255 is special, it means the bitrate is encoded in
> > > byte 66 in units of 250MBaud.  Add support for parsing these bit
> > > rates.
> > 
> > Hi Russell,
> > 
> > it seems from the code either that 0 is also special or its
> > handling has been optimised. Perhaps that would be worth mentioning
> > in the changelog too.
> 
> The text of SFF8472 rev 12.2:
> 
> 5.7     BR, nominal [Address A0h, Byte 12]
> The nominal bit (signaling) rate (BR, nominal) is specified in units of
> 100MBd, rounded off to the nearest 100MBd. The bit rate includes those
> bits necessary to encode and delimit the signal as well as those bits
> carrying data information. A value of FFh indicates the bit rate is
> greater than 25.0Gb/s and addresses 66 and 67 are used to determine
> bit rate. A value of 0 indicates that the bit rate is not specified and
> must be determined from the transceiver technology. The actual
> information transfer rate will depend on the encoding of the data, as
> defined by the encoding value.
> 
> 8.4    BR, max [Address A0h, Byte 66]
> If address 12 is not set to FFh, the upper bit rate limit at which the
> transceiver will still meet its specifications (BR, max) is specified
> in units of 1% above the nominal bit rate. If address 12 is set to FFh,
> the nominal bit (signaling) rate (BR, nominal) is specified in units of
> 250 MBd, rounded off to the nearest 250 MBd. A value of 00h indicates
> that this field is not specified.
> 
> 8.5    BR, min [Address A0h, Byte 67]
> If address 12 is not set to FFh, the lower bit rate limit at which the
> transceiver will still meet its specifications (BR, min) is specified in
> units of 1% below the nominal bit rate. If address 12 is set to FFh, the
> limit range of bit rates specified in units of +/- 1% around the nominal
> signaling rate. A value of zero indicates that this field is not
> specified.
> 
> So I guess you could have a br_nom == 0 (meaning it should be derived
> from other information) but max/min != 0 - which would be complex to
> implement, and means that we're doing significant interpretation of
> the contents.

Thanks Russell,

tricky indeed. My suggestion is that something like the last paragraph
be included in the changelog. But if you feel otherwise I won't push the
issue any further.

> 
> > 
> > > 
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > ---
> > >  sfpid.c | 19 ++++++++++++++++---
> > >  1 file changed, 16 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/sfpid.c b/sfpid.c
> > > index a1753d3a535f..71f0939c6282 100644
> > > --- a/sfpid.c
> > > +++ b/sfpid.c
> > > @@ -328,11 +328,24 @@ void sff8079_show_all(const __u8 *id)
> > >  {
> > >  	sff8079_show_identifier(id);
> > >  	if (((id[0] == 0x02) || (id[0] == 0x03)) && (id[1] == 0x04)) {
> > > +		unsigned int br_nom, br_min, br_max;
> > > +
> > > +		if (id[12] == 0) {
> > > +			br_nom = br_min = br_max = 0;
> > > +		} else if (id[12] == 255) {
> > > +			br_nom = id[66] * 250;
> > > +			br_max = id[67];
> > > +			br_min = id[67];
> > > +		} else {
> > > +			br_nom = id[12] * 100;
> > > +			br_max = id[66];
> > > +			br_min = id[67];
> > > +		}
> > >  		sff8079_show_ext_identifier(id);
> > >  		sff8079_show_connector(id);
> > >  		sff8079_show_transceiver(id);
> > >  		sff8079_show_encoding(id);
> > > -		sff8079_show_value_with_unit(id, 12, "BR, Nominal", 100, "MBd");
> > > +		printf("\t%-41s : %u%s\n", "BR, Nominal", br_nom, "MBd");
> > >  		sff8079_show_rate_identifier(id);
> > >  		sff8079_show_value_with_unit(id, 14,
> > >  					     "Length (SMF,km)", 1, "km");
> > > @@ -348,8 +361,8 @@ void sff8079_show_all(const __u8 *id)
> > >  		sff8079_show_ascii(id, 40, 55, "Vendor PN");
> > >  		sff8079_show_ascii(id, 56, 59, "Vendor rev");
> > >  		sff8079_show_options(id);
> > > -		sff8079_show_value_with_unit(id, 66, "BR margin, max", 1, "%");
> > > -		sff8079_show_value_with_unit(id, 67, "BR margin, min", 1, "%");
> > > +		printf("\t%-41s : %u%s\n", "BR margin, max", br_max, "%");
> > > +		printf("\t%-41s : %u%s\n", "BR margin, min", br_min, "%");
> > >  		sff8079_show_ascii(id, 68, 83, "Vendor SN");
> > >  		sff8079_show_ascii(id, 84, 91, "Date code");
> > >  	}
> > > -- 
> > > 2.7.4
> > > 
> > 
> > 
> > 
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up
