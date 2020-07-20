Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0FB2261A8
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 16:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgGTOLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 10:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgGTOLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 10:11:52 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5C9C0619D2
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 07:11:52 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id p1so8744136pls.4
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 07:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=A726Yr9VsatMyQV/kYLfRoN4wKZEMkU5BbvHaxH3Y1g=;
        b=TNn4H2SYZUDvgBNteh+4GCRlw+QsoycRFIf7r9Onszr0XDDSS8nM3efH0oB5gY7uU5
         39GT+YGvgKlA8xlX3FFqBtqZu7iy3CcCx46vfX+bsYMQ0hVSx7WlFC8n+5AQX36Nha3A
         QeTOzJZcwifotLzPdMvIzh62Yd9Z5kE2JRSMrjFmKcAezdevH28IpgRVgGT2nwXQb9Dv
         w9eSc3ED2ixVlbYOWarpiHpyqt7wGgkWtDmM+o54dAr1HtRnXesMLD9UKJt7bEA+SaW3
         If94qNHatzEXzcLL77NZ78UO4RyZ7ypEpJcGTW9nffqdoY/ViIPpg/D5gS9QssmMmkaL
         xHMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=A726Yr9VsatMyQV/kYLfRoN4wKZEMkU5BbvHaxH3Y1g=;
        b=DhbSHN6LbK+ZUkeZAHwQWyWU4O/ldOuUEpMiNhs7VEbeDMqr9lmMwHQVt38tjcy8oY
         WaSG7vi7JeqYfI0CGEZGOKvtcYCBPWsy8xq4QOXQE8dahC2aD6yKPz0HKAsDz08Fryea
         XEGPPQ8wKR5AK8oW5svq9FvIMwqSLFohrCIdfFl5fuyZXzKpB4LEDAVXJAC+oEMU6egJ
         N34DGAb0N5f//feZz4zc+CYOehZmQjfvTDHGDCHYdKMBqZBwPF+a7YnM3QIcOUM/Zzw1
         WirzaZePPjGiJF2vWfQHZ8ULfdOboI5MyHHLnPpAW2Dq8e7fxo//gOauXvvIgPEeWJho
         jexQ==
X-Gm-Message-State: AOAM530pzZ7vQAhGylSqNjApM/CaV1dWAUk1uW1DECmJtNbGyQbkldZz
        PtoBcKsMp+qUv3vUISCpFLk=
X-Google-Smtp-Source: ABdhPJz9ezoWrx0hcR3y/o8GbZD/TJVJwlMIiB9Y4kAYyJK/V1+YNvKOy554acSZf7Ksb4BK1e8OmQ==
X-Received: by 2002:a17:90a:22ab:: with SMTP id s40mr25566644pjc.117.1595254312183;
        Mon, 20 Jul 2020 07:11:52 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id d12sm17122813pfh.196.2020.07.20.07.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 07:11:51 -0700 (PDT)
Date:   Mon, 20 Jul 2020 07:11:49 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        jacob.e.keller@intel.com, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v2 net-next 0/3] Fully describe the waveform for PTP
 periodic output
Message-ID: <20200720141149.GA16001@hoboy>
References: <20200716224531.1040140-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716224531.1040140-1-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 01:45:28AM +0300, Vladimir Oltean wrote:
> With these patches, struct ptp_perout_request now basically describes a
> general-purpose square wave.

Nice to see kernel support for a frequency output.  Would you be able
to add this mode into the user space test program, too?

   tools/testing/selftests/ptp/testptp.c

Thanks,
Richard
