Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33BE2BABB8
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 15:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgKTOQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 09:16:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgKTOQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 09:16:26 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14168C0613CF;
        Fri, 20 Nov 2020 06:16:25 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id 10so7980751pfp.5;
        Fri, 20 Nov 2020 06:16:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KEjEGhmEzvhfjxAnQoE9R0iga9goTRtUqlUhzJyg2qQ=;
        b=rmu5CylR6oML6jLJKaGGZylZYDXpFUleODzdx8ODXqkwL5ZbtvJrM7cTSVI8T8uVxE
         P+Unb1Nhc/bMtsDzbttn263z0bjakrJ8R0D1Xcs16DM2HZUdYI/dUfeiJGJYY0P3hhu1
         odVny6iLsWsR70vTyW5khgYoMf8rap8qAD7SxwU3kSiCTcthD6k7fQDL2ZDYB1EWjzzx
         xlxXFTC9DpGqALn7JBUNdJHRlmo/MQtKB7pZ9yCvZSeNG7CAbG/hAFrUfByLlc+md6uw
         xprRB8DTj6TdDZRK/9q/8dpwUdawbsq6TK8Wj5qwnOt0SCObdL4cj3ciw3/jScClA8H1
         9F6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KEjEGhmEzvhfjxAnQoE9R0iga9goTRtUqlUhzJyg2qQ=;
        b=GRdcfvtjhRnlZRbBg67VKOTEauJ5ByMMjtoxnw92DCmGXWkn1TQtui40CYHY4ButUz
         d0oXlj5MpVjjoEeo7n/H6Z3v59iByZrvn+o8aAFhR5+QXPNH/InhLrOabwsjq7dB27zn
         ZwlvFiameFkwbvmhJHZ+fjY86ITC2/1v2Hu+Rdqo5VlCr+yErPFZCWXOO/Ugis6/DhAg
         vwmdCVo54uQjMu6Bi/RrvbWsDGXqPcTANdIP/bJxHlAnyJzVJXq4aewkKgVzdia04xAN
         cY0qa0+1lR4myGuRWBSvMSj3dLv2yUeBJuaf6SW0cv8kfjhriF0FH5Dty1rU8SiYdlq6
         7yKQ==
X-Gm-Message-State: AOAM530rBGKlXtuTVF7lNt+p/3lhGIKiH7H77+QE/Q5cHZDMD3XjMSdn
        49RZ0y4EqyTfkhwkSBsRoU+fyBxQ2jc=
X-Google-Smtp-Source: ABdhPJwSl/mRXdT+kWI2/PMGP7CwOB4vp2FCA92dJObq/nTTfL/VbZmWq8QnHEv9bdX+qhsZ+aCKxw==
X-Received: by 2002:a63:ca0a:: with SMTP id n10mr17143580pgi.326.1605881784581;
        Fri, 20 Nov 2020 06:16:24 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id kr2sm3984871pjb.31.2020.11.20.06.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 06:16:23 -0800 (PST)
Date:   Fri, 20 Nov 2020 06:16:21 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        intel-wired-lan@lists.osuosl.org, andre.guedes@intel.com,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        bhelgaas@google.com
Subject: Re: [Intel-wired-lan] [PATCH next-queue v2 3/3] igc: Add support for
 PTP getcrosststamp()
Message-ID: <20201120141621.GC7027@hoboy.vegasvil.org>
References: <20201114025704.GA15240@hoboy.vegasvil.org>
 <874klo7pwp.fsf@intel.com>
 <20201117014926.GA26272@hoboy.vegasvil.org>
 <87d00b5uj7.fsf@intel.com>
 <20201118125451.GC23320@hoboy.vegasvil.org>
 <87wnyi2o1e.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wnyi2o1e.fsf@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 04:22:37PM -0800, Vinicius Costa Gomes wrote:

> Talking with the hardware folks, they recommended using the periodic
> method, the one shot method was implemented as a debug/evaluation aid.

I'm guessing ...

The HW generates pairs of time stamps, right?

And these land in the device driver by means of an interrupt, right?

If that is so, then maybe the best way to expose the pair to user
space is to have a readable character device, like we have for the
PTP_EXTTS_REQUEST2.  The ioctl to enable reporting could also set the
message rate.

Although it will be a bit clunky, it looks like we have reserved room
enough for a second, eight-byte time stamp.


	struct ptp_clock_time {
		__s64 sec;  /* seconds */
		__u32 nsec; /* nanoseconds */
		__u32 reserved;
// four here
	};

	struct ptp_extts_event {
		struct ptp_clock_time t; /* Time event occured. */
		unsigned int index;      /* Which channel produced the event. */
		unsigned int flags;      /* Reserved for future use. */
		unsigned int rsv[2];     /* Reserved for future use. */
// eight here
	};


You could set 'flags' to mark this as a time stamp pair, and then
stuff the system time stamp into rsv[2].

Thoughts?

Richard


