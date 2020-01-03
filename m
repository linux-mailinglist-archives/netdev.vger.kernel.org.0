Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0861212F3D9
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 05:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgACEoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 23:44:14 -0500
Received: from mail-pl1-f182.google.com ([209.85.214.182]:38960 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgACEoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 23:44:14 -0500
Received: by mail-pl1-f182.google.com with SMTP id g6so15667998plp.6
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 20:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=QKGh1JUIbBQrvzsdz7YSOk7ZpvfE3AB72QW/FLjpMF8=;
        b=aw1cVlM5Jwbz3VbJIiPJxech3fQu0dRdi0ffGSoEEXSwEqHGaQNMmJIX+Yy6P0TkIb
         WP76APhVsxUzPc6bKJmjl/EHZrAsHO06eIuRVeJCAZo3H16WgSQo0FeuKlTr2qmQfZoJ
         VvVib6M0g7LbPwwTZ0uia4CUelESwTh/tVk/oIc3mfiODnWOriO9kWaRwGibUhUG0aS5
         z6mKDN6spvy/QxJ6NW4WwGN6aItOwxBsxNFT5+cAq2sem+dUINTSk6QU8zmYvbs7GvKH
         wNnuWwnWEToo263zpKiitdlzuTFR8DClpTuGXpYdT3wFbodgayGjExaxKs8IguZkjK+z
         rfew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QKGh1JUIbBQrvzsdz7YSOk7ZpvfE3AB72QW/FLjpMF8=;
        b=cTLsbg1GMKLSVlWQjV0o6WMrIjmoEjkFIiCT7EUZ6GpLDh3vqWNRrpoBSqShK1y7xN
         KxV/3Qz3PCjFiE8Ateoa1qxZEaSZK4QZf5QAorCIQp5bzHVKF6LPMfF1EWR4jCpNMPuI
         39ZhC+payhc2aU4K/JgBs5F5bQCfavOT674z9V+TZiji85NprNImwFN3T+c1J3PqBblu
         AvxBfaGlqhq1oP3g1ZgnSaNNiCkAa9GaIxYyy9yJsnmmr/phYzzejnv0RvB9N8dj1myz
         V5g5SiC53QsZ3jrQKSLyh2/bJoTxfSCTUUrJWIRuWsZh9AH+18u2qJYHbxzOGgcZf62T
         +gyA==
X-Gm-Message-State: APjAAAUEiXZWIveG1rYt1g+3dqikC659dvZpvemuKTnX2QZRMhRObJPr
        sDdc/DLWzvRygOqZw8YUce8=
X-Google-Smtp-Source: APXvYqyh5f9dPNo3fTvmKgFXgHjMR75AZ1r0o+NZxIsuQAgTz6M7RkJxWOF4G+i+15MA+PH1+I46XA==
X-Received: by 2002:a17:90a:d3c3:: with SMTP id d3mr23448149pjw.53.1578026653317;
        Thu, 02 Jan 2020 20:44:13 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:464:9ee1:192c:21fc? ([2601:282:800:7a:464:9ee1:192c:21fc])
        by smtp.googlemail.com with ESMTPSA id b17sm54524561pfb.146.2020.01.02.20.44.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jan 2020 20:44:12 -0800 (PST)
Subject: Re: VRF + ip xfrm, egress ESP packet looping when qdisc configured
To:     Trev Larock <trev@larock.ca>, netdev@vger.kernel.org,
        Ben Greear <greearb@candelatech.com>
References: <CAHgT=KfpKenfzn3+uiVdF-B3mGv30Ngu70y6Zn+wH0GcGcDFYQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ff36e5d0-0b01-9683-1698-474468067402@gmail.com>
Date:   Thu, 2 Jan 2020 21:44:07 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <CAHgT=KfpKenfzn3+uiVdF-B3mGv30Ngu70y6Zn+wH0GcGcDFYQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/2/20 4:11 PM, Trev Larock wrote:
> Transport mode is same behavior.  Anyone have reference config for vrf + xfrm?

Ben, cc-ed, has done some IPsec + VRF work.

I have not done much wth xfrm + vrf. Can you re-create this with network
namespaces? If so, send the commands and I will take a look when I can.
