Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32E42E1025
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 04:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389240AbfJWCmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 22:42:06 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40532 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbfJWCmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 22:42:06 -0400
Received: by mail-pg1-f196.google.com with SMTP id 15so5841191pgt.7
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 19:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=gzdQ6QyER4GCp7x/HAB4Hp2BiPdgRoRKpqK4nobFYss=;
        b=AEqZhswJ4HBuVzty3iPOoXyZLy21xF2W5EapH5AeiPrrYMOOIF+m7DpqcX0Ud9e8pL
         GP8wRXbM+odRwxYWVEojnmpqwTl110QRXD+7bCYG75uTKv41wQIijlf7JMwNkxwXI6Lt
         cKK0y4spy6CxZYqT6CsyX8yb2ryMEi4p3RAznufg2/SX2XFzVHv8dTlhYz91A0YfH5Ep
         4NDbWGxregsamlguOAHCKd/Hkt4bb747EU5E4INp0H9HH1s1ZhF1yTCKK6YWkY5/qKgu
         9e23zL28c6VGnNlKZ0lCeJS2cjRlJn1MC4XHnall6siE65jeP/vKe2LdTIfgZtUcMi1v
         5LqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=gzdQ6QyER4GCp7x/HAB4Hp2BiPdgRoRKpqK4nobFYss=;
        b=GXe0sbdRd8oboAdcRC2OI7b5t5R3otmAWu9FCKhJGsMJOUxBBQfvc4soJIdaxwHH5e
         vpTsaVvM8sQ5SGOp+h/viBiFUVGm576135NN6EFj206priHJuw8Napdnz5GzZ2l9P7XW
         h87WAWrV04gv6p4psqJTtWqSq01rIY+JDdO/fJfbBteM9ZEg1FD8XmQWlV4Zr7dNdhHs
         P7eZoDhZp9kIr2WpemT/vCLI5PynrVwL6nQ2xPSccsZmpDScgPSABOgKDwhDR0ZtZ6QA
         aA9lMNxYlvbeTt83i990b1mf+eiG1WVOtLv3DyN054lhnH1YvAwbzU74V1VRxViAXpmw
         u5/A==
X-Gm-Message-State: APjAAAWAPVICVD6ml8HzeTfr59zX8ksgERz32R9T9cIRzzUADa1fW031
        tulJoUq/o+94kSkacArVeLOvW47L1B0=
X-Google-Smtp-Source: APXvYqxBkeDDRVBTL2MmGcCMTKNBnqVtBNNrYpYtK78+mN9yWJRixA8PbZQJLYhaM6sAr1NRbngi7w==
X-Received: by 2002:a62:685:: with SMTP id 127mr7965367pfg.227.1571798525365;
        Tue, 22 Oct 2019 19:42:05 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id o20sm4400154pfp.16.2019.10.22.19.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 19:42:05 -0700 (PDT)
Date:   Tue, 22 Oct 2019 19:42:01 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH net-next 2/6] ionic: reverse an interrupt coalesce
 calculation
Message-ID: <20191022194201.44520af4@cakuba.netronome.com>
In-Reply-To: <a81e4f85-68db-555d-047d-b6d6f5997b68@pensando.io>
References: <20191022203113.30015-1-snelson@pensando.io>
        <20191022203113.30015-3-snelson@pensando.io>
        <20191023012225.GJ5707@lunn.ch>
        <a81e4f85-68db-555d-047d-b6d6f5997b68@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Oct 2019 19:09:40 -0700, Shannon Nelson wrote:
> On 10/22/19 6:22 PM, Andrew Lunn wrote:
> > On Tue, Oct 22, 2019 at 01:31:09PM -0700, Shannon Nelson wrote: =20
> >> Fix the initial interrupt coalesce usec-to-hw setting
> >> to actually be usec-to-hw.
> >>
> >> Fixes: 780eded34ccc ("ionic: report users coalesce request")
> >> Signed-off-by: Shannon Nelson <snelson@pensando.io> =20
> > Hi Shannon
> >
> > How bad is this? Should it be backported? If so, you should send it as
> > a separate patch for net.
>=20
> Well, it doesn't "break" anything, but it does end up initializing the=20
> coalesce value to 0, aka turns it off.=C2=A0 The easy work-around is for =
the=20
> user to set a new value, then all is well.=C2=A0 However, since v5.4 is=20
> intended as an LTS, this probably should get promoted into net.=C2=A0 If=
=20
> there aren't many other comments, I'll likely turn this around tomorrow=20
> afternoon.

I think the commit in question only landed in net-next after the merge
window. Perhaps the larger problem with the coalescing could have been
fixed in net, but now I think it may be too late, no?
