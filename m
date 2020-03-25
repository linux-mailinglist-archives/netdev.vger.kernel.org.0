Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E64D71925F9
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 11:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbgCYKlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 06:41:49 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43823 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbgCYKlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 06:41:49 -0400
Received: by mail-wr1-f66.google.com with SMTP id b2so2283583wrj.10
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 03:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=neOGMMS8i5KRkPfaWBr21mXvahj1YdK4pGNYSNow6FQ=;
        b=hqaswIQ5hJ2/F/7k3C1M5Q5idCUG9kUi8+PPiKdl2677rm22jfFQyP3EQnxotgOvi9
         4L4vrHt6IU+DwUF283g0svAD+zKOLQryFA1MViz6SLDQcaabhXZQEVoVng8NejqgSt1F
         FiynwgD0RzIxEBOgEaH7quBoVDsRFC6l9BfKOR2lTpP8KIkuE59q1YdVnhxATUshlZZ7
         x5gfJLuRH7ReuWyf9GT6LR2ZCyH2z2Ba+rLWdvZJrfKZS9mwB1NVk1+Q+3h07aA0j9Ae
         Fl9kvA9ZueiyrAKU/ODfMrhjRq9Cn5zKnFGZLewRTgOBcSoGsI9JE3ayAfpLfXIuTlPh
         3+Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=neOGMMS8i5KRkPfaWBr21mXvahj1YdK4pGNYSNow6FQ=;
        b=X1yDPVfV7fKLpPLRCLJbPYcDa2U+m8M3KA7cM6w+KOommhCbSGgvN1v6yI0UtkhK4L
         tra7P4eK7i5V9LHVVMbUfrm1aW/scr2zEHlEcw+c5WN0zNdt0IjGiS69GEqgKH29xRJV
         AlK8rTWIj3CVjFoljXuLERfJ1UiGGxIN6OgMXHTiMRp0t8PbRCSKD6LOz2IcKE0fwpJ0
         +49PvzoHw4T0RnZLMX6anj7HZtv3C99oEGH6esx85/syiBqpqF8j3uQwMpIVTwSlp2w5
         YGqzF7eb63NqyDGl9cOTmnmEydXztDTcTxNb1iLCxnMfikDkBMjwa963IIXTprkOC8nx
         zkhQ==
X-Gm-Message-State: ANhLgQ3Lwj7rhj1c5eOOwQX4/+lch3TONArbIy2oUFqTvXJdP1ski9DY
        +SwTjMF+k6mkPqTPChg+D7moDA==
X-Google-Smtp-Source: ADFU+vttVGKF5WS1i+ZET6Aa5dBM1Yeu2yLRJZtzbxobGABcmtmXURD2v+hRMCd3Uo02mblNil4YqQ==
X-Received: by 2002:adf:ce0d:: with SMTP id p13mr2694715wrn.8.1585132907507;
        Wed, 25 Mar 2020 03:41:47 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id w66sm1255661wma.38.2020.03.25.03.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 03:41:46 -0700 (PDT)
Date:   Wed, 25 Mar 2020 11:41:46 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@mellanox.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 01/15] devlink: Add packet trap policers support
Message-ID: <20200325104146.GU11304@nanopsycho.orion>
References: <20200324193250.1322038-1-idosch@idosch.org>
 <20200324193250.1322038-2-idosch@idosch.org>
 <20200324203109.71e1efc6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200325094143.GA1332836@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325094143.GA1332836@splinter>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Mar 25, 2020 at 10:41:43AM CET, idosch@idosch.org wrote:
>On Tue, Mar 24, 2020 at 08:31:09PM -0700, Jakub Kicinski wrote:
>> On Tue, 24 Mar 2020 21:32:36 +0200 Ido Schimmel wrote:
>> > +/**
>> > + * devlink_trap_policers_register - Register packet trap policers with devlink.
>> > + * @devlink: devlink.
>> > + * @policers: Packet trap policers.
>> > + * @policers_count: Count of provided packet trap policers.
>> > + *
>> > + * Return: Non-zero value on failure.
>> > + */
>> > +int
>> > +devlink_trap_policers_register(struct devlink *devlink,
>> > +			       const struct devlink_trap_policer *policers,
>> > +			       size_t policers_count)
>> > +{
>> > +	int i, err;
>> > +
>> > +	mutex_lock(&devlink->lock);
>> > +	for (i = 0; i < policers_count; i++) {
>> > +		const struct devlink_trap_policer *policer = &policers[i];
>> > +
>> > +		if (WARN_ON(policer->id == 0)) {
>> > +			err = -EINVAL;
>> > +			goto err_trap_policer_verify;
>> > +		}
>> > +
>> > +		err = devlink_trap_policer_register(devlink, policer);
>> > +		if (err)
>> > +			goto err_trap_policer_register;
>> > +	}
>> > +	mutex_unlock(&devlink->lock);
>> > +
>> > +	return 0;
>> > +
>> > +err_trap_policer_register:
>> > +err_trap_policer_verify:
>> 
>> nit: as you probably know the label names are not really in compliance
>> with:
>> https://www.kernel.org/doc/html/latest/process/coding-style.html#centralized-exiting-of-functions
>> ;)
>
>Hi Jakub, thanks for the thorough review!
>
>I assume you're referring to the fact that the label does not say what
>the goto does? It seems that the coding style guide also allows for
>labels that indicate why the label exists: "Choose label names which say
>what the goto does or why the goto exists".
>
>This is the form I'm used to, but I do adjust the names in code that
>uses the other form (such as in netdevsim).
>
>I already used this form in previous devlink submissions, so I would
>like to stick to it unless you/Jiri have strong preference here.

Yeah, let's have this per-code. In devlink, this is how it's done. Let's
be consistent.


>
>> 
>> > +	for (i--; i >= 0; i--)
>> > +		devlink_trap_policer_unregister(devlink, &policers[i]);
>> > +	mutex_unlock(&devlink->lock);
>> > +	return err;
>> > +}
>> > +EXPORT_SYMBOL_GPL(devlink_trap_policers_register);
