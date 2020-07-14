Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684D621F40B
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbgGNO1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgGNO1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:27:19 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38337C061755;
        Tue, 14 Jul 2020 07:27:19 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id q7so23013789ljm.1;
        Tue, 14 Jul 2020 07:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=p48k422neEowRT4qHhc+RDlrp+EdfHDwdlbp2jQOvCM=;
        b=jX0/XZi6VM34IzPPqxD6AQZ6S9xG0YSKzYevqp0Oyh2e6rYk+ZlVgm4+SVaheK2FX/
         V7X1sQsbfcLFq+rhbO8cpW/j554dVaIbbOhlQCC/KyNIxwwjmIJ3gK/AuW1GwnczUR5S
         hghJpSl5XAjUPn0vEcDvhmCejFtutwkpclYb7aUhffQP8Pw89tAergrGOxyhKgnNxXCe
         jJJK3CS6+CitgjgzeueHD7Rhkjw/EtGBBMC2TN8JjGx2I/+8JEv+e45SB75nMvcbyLuA
         18vZFq3ShKkP9MpJp51h5lGt/bG7p/qPvikbsDHAqu6GEhhJkBqWSVPOqaEP8RWtACLx
         ZAZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=p48k422neEowRT4qHhc+RDlrp+EdfHDwdlbp2jQOvCM=;
        b=hCp+ic6oElpPHOi8qe25Ew2eqyWZ4WwYdKcsaLbds3tFutTqttYHACXdm3ziIwOHR3
         MlZeM3qZ3kbHz3axRpOQ6HNLYrRh2e50Cn7ubYwZ0NQhUk8MGEoCbKqFY0ugtTOu0AJ0
         o1/e9TJ1QUE0RzJMSz2MmCUCn8OPB/5C+5tViKKQ3ddFSmPQqsJnCVwGrif4Q4VcwLZD
         fM+hoiqLAk8DDM5/8C7blO4CLE8tbP6f8DO/wY10DyVgZqMDXozWe3LhHGY4j2K6bDO8
         AXgABqFw5DZtIwl/AEalIPxIzizQ6PhJQqdYFohtkq0KYT4BOG9nDmrHFRWydJWNoMIk
         zVUA==
X-Gm-Message-State: AOAM533GiVt+v5ZqbVhPQ3t3eezzhEaaPQuSDAqfzP7O8s8Y4kuS7M2G
        ObIR5uPdxOuoxgEwyt77vn9weL6c
X-Google-Smtp-Source: ABdhPJyWSAjS90kybSTOTgTjsWUmIwLBT75PxyI5OyD5GedwU0e5KH94rDKYbIs+4ahXHd8fUCLTKw==
X-Received: by 2002:a05:651c:1183:: with SMTP id w3mr2353696ljo.54.1594736837705;
        Tue, 14 Jul 2020 07:27:17 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id 190sm4701440ljf.38.2020.07.14.07.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 07:27:16 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v2 net] net: fec: fix hardware time stamping by external
 devices
References: <20200706142616.25192-1-sorganov@gmail.com>
        <20200711120842.2631-1-sorganov@gmail.com>
        <20200714140134.GA19806@hoboy>
Date:   Tue, 14 Jul 2020 17:27:16 +0300
In-Reply-To: <20200714140134.GA19806@hoboy> (Richard Cochran's message of
        "Tue, 14 Jul 2020 07:01:34 -0700")
Message-ID: <87o8oidvej.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Richard Cochran <richardcochran@gmail.com> writes:

> On Sat, Jul 11, 2020 at 03:08:42PM +0300, Sergey Organov wrote:
>> Fix support for external PTP-aware devices such as DSA or PTP PHY:
>> 
>> Make sure we never time stamp tx packets when hardware time stamping
>> is disabled.
>> 
>> Check for PTP PHY being in use and then pass ioctls related to time
>> stamping of Ethernet packets to the PTP PHY rather than handle them
>> ourselves. In addition, disable our own hardware time stamping in this
>> case.
>> 
>> Fixes: 6605b73 ("FEC: Add time stamping code and a PTP hardware clock")
>> Signed-off-by: Sergey Organov <sorganov@gmail.com>
>> ---
>> 
>> v2:
>>   - Extracted from larger patch series
>>   - Description/comments updated according to discussions
>>   - Added Fixes: tag
>
> Acked-by: Richard Cochran <richardcochran@gmail.com>

Thanks for reviewing!

-- Sergey
