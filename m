Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D6A2185D3
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 13:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbgGHLPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 07:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgGHLPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 07:15:21 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EE6C08C5DC;
        Wed,  8 Jul 2020 04:15:21 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id w2so20711657pgg.10;
        Wed, 08 Jul 2020 04:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=x8CzCNCVY2DEFkmEo9x47ULwFWJK87T1/eVz2vgJvtc=;
        b=pGGZKRPVLWhXkxQyhu202FK1t/DHwD6KvHlcedJwlR+AT3oBF2senhHisRpi+/sFxQ
         VOVleXcjeU4/mvq5mIW4+tPMbZx1YLUmua1wrcXzcAyeo0jU85WN7E12tKwOHelJcttf
         uvv+UkLOo2NVWTZzZ1ZgSLdE8bAimmrXTUXkkIBfgq84XpiQ96QuOAcSQMAJm8m8cto5
         VrwJge2/7w8WZW6gsbOmVG+U6iSZNb8XaFVZ7GRtOrVYHgCZP8gpn5cxMCavGkBIyw52
         Fx9VTUdOqYt6NJ6vaLgrLtU7YVVgN3LCmM+Xn1DPh8NiOmbXTazETk53+1D8PeDJ9aj7
         MKgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=x8CzCNCVY2DEFkmEo9x47ULwFWJK87T1/eVz2vgJvtc=;
        b=lKEczzJFhINcpqYHjprGcfGXBOngjlXB+sDsJxoTptucvqmOE56p84ihKuA6nO1swQ
         q0wsWOvMYd47wVepG2kMr17y9hrhl8MM7TGbg5v7Fpws2IhEdwZ6RRDvMo/dFrhwMJV7
         Qrm3tq2k67cY8M7dXNox/HHaW+i4y+uflDVIPfsuxbWMiwXJbtPXCICTTdX5G01Q7KKk
         0D1Pkg7BF4aWbDo0VopCQJKJ67ehTyXwieOKDQknsphQ2yUEyaFWGUQ1arnsPo4PR2d2
         vHA636YW8VvFIi8iGbvN1AWGcOGmgb7OAdK9ZAykDPNwceeuvqmaUuEZSN8U57LyvSFK
         KI8w==
X-Gm-Message-State: AOAM531/T5sR8mOUDD+M1CUon5GtUtD+Sw4sxvc9EA8BTcyTEixjUPpv
        Qi9pjfNu6d9kOGW0DxyUBAA=
X-Google-Smtp-Source: ABdhPJwqHcvbEmt6GIaYgHDCndZvhyku4OdMSPqRUpWN7nzz3X1cjRdWKtIL1vykrYTQw0ikP14Dog==
X-Received: by 2002:a63:d40d:: with SMTP id a13mr48854602pgh.225.1594206920643;
        Wed, 08 Jul 2020 04:15:20 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id d22sm24858203pfd.105.2020.07.08.04.15.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 04:15:20 -0700 (PDT)
Date:   Wed, 8 Jul 2020 04:15:18 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Sergey Organov <sorganov@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH  3/5] net: fec: initialize clock with 0 rather than
 current kernel time
Message-ID: <20200708111518.GF9080@hoboy>
References: <20200706142616.25192-1-sorganov@gmail.com>
 <20200706142616.25192-4-sorganov@gmail.com>
 <20200706152721.3j54m73bm673zlnj@skbuf>
 <874kqksdrb.fsf@osv.gnss.ru>
 <20200707063651.zpt6bblizo5r3kir@skbuf>
 <87sge371hv.fsf@osv.gnss.ru>
 <20200707164329.pm4p73nzbsda3sfv@skbuf>
 <87sge345ho.fsf@osv.gnss.ru>
 <20200707171233.et6zrwfqq7fddz2r@skbuf>
 <87zh8b1a5i.fsf@osv.gnss.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zh8b1a5i.fsf@osv.gnss.ru>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 07, 2020 at 08:56:41PM +0300, Sergey Organov wrote:
> It won't. Supposedly it'd force clock (that doesn't tick by default and
> stays at 0) to start ticking.

No existing clockid_t has this behavior.  Consider CLOCK_REALTIME or
CLOCK_MONOTONIC.
 
The PHC must act the same as the other POSIX clocks.

Thanks,
Richard


