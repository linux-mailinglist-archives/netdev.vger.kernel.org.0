Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0191624E47E
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 03:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgHVBgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 21:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgHVBgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 21:36:09 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A69DC061574
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 18:30:12 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id f5so1662412plr.9
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 18:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5FdGCOSh0yGq5LOdKg1cw6G6slHfFg4GcWGqdDvjTBQ=;
        b=DxUNEdML933X+ar/XoNGfoEBuHpdwgrmWIhk+0OcsF0He/yLLSZI5qArp/ruHKfVxT
         MtRDKtzGXbx6+FHZfNmFnVR9D8Jy/fr2m1y4Zcjytvf+dTrLbvmPbTpoFhmWpO2x/wDQ
         7j9/l6sOWtMJiwbrD3dpQXcnNActfp5orI5p7RGxSg7ThFqWkiEFJVAsoa5pkT29UqS3
         q0XwsnoApctrhbBwefEuVuWwRYpypCY0hCPOy48n3UaLT8Dx/7IeAlxBstA2mZQ09QMx
         2IGfXkfWdxT/PaCAkvjpV9lyt6kdt+WuNRfIEFJF/g16EmzFBOkCsyFWLXoSYqIW9WXz
         B+JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5FdGCOSh0yGq5LOdKg1cw6G6slHfFg4GcWGqdDvjTBQ=;
        b=E9SNrMujIqa5CYoSReSNec7Gj/vbtHzdkgR0uQCBhywU6DrXX/Hocgc6CgbMoU/cn/
         FJKTKCLR6mAkzKEKyTSgjeoFxlzLzaggUUgZPi6d7LxkSGpUavKJ6jaEqPCE1F407vDp
         AAtJzovqDPOd+uY+wOsiQ8PiXGHS/8Q1pFW7sSJMDBbcKSTgmUH1piqPdrf/GdgHgLzM
         yYLbEy+vXotnpNu9BVOgZeQhqZUUb2YM9bEsuQaya75ZdbkpcJnAcfsi76Cb8yr4KBc2
         ImjYwAYeMm9VibZOK/t0JOuaCXFA1G9QQ02/b4YLoIQZJtaLSKQtwopECEblHdCn9L2L
         EGZw==
X-Gm-Message-State: AOAM530jT0aO9G9wpGVCcl4tHyHKYY/tD8ceqHyC0qOZx7VNs8CX6xe9
        M2GcNawIfG+JrrTN1obOCav0mJZWo9aiNA==
X-Google-Smtp-Source: ABdhPJzT3Rxj5ys+Go+GlnOkGA6Vk00z1TpsJPXXCiQezVriHK4KdnqOQXFxSVB1v3OgT4cM/UwVHg==
X-Received: by 2002:a17:90a:6481:: with SMTP id h1mr4847063pjj.18.1598059811681;
        Fri, 21 Aug 2020 18:30:11 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id r77sm4041279pfc.193.2020.08.21.18.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 18:30:11 -0700 (PDT)
Date:   Fri, 21 Aug 2020 18:30:02 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roopa Prabhu <roopa@nvidia.com>
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>, <dsahern@gmail.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH iproute2 net-next] iplink: add support for protodown
 reason
Message-ID: <20200821183002.7bfc7aa0@hermes.lan>
In-Reply-To: <78abb0f7-7043-2612-58de-e64ecefd7ac5@nvidia.com>
References: <20200821035202.15612-1-roopa@cumulusnetworks.com>
        <20200820213649.7cd6aa3f@hermes.lan>
        <1ad9fc74-db30-fee7-53c8-d1c208b8f9ec@nvidia.com>
        <78abb0f7-7043-2612-58de-e64ecefd7ac5@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Aug 2020 14:09:14 -0700
Roopa Prabhu <roopa@nvidia.com> wrote:

> On 8/20/20 10:18 PM, Roopa Prabhu wrote:
> >
> > On 8/20/20 9:36 PM, Stephen Hemminger wrote: =20
> >>
> >>
> >> On Thu, 20 Aug 2020 20:52:02 -0700
> >> Roopa Prabhu <roopa@cumulusnetworks.com> wrote:
> >> =20
> >>> +=C2=A0=C2=A0=C2=A0=C2=A0 if (tb[IFLA_PROTO_DOWN]) {
> >>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 if (rta_getattr_u8(tb[IFLA_PROTO_DOWN]))
> >>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 print_bool(PRINT_ANY,
> >>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "proto_down", " protodown on =
", true); =20
> >> In general my preference is to use print_null() for presence flags.
> >> Otherwise you have to handle the false case in JSON as a special case.=
 =20
> >
> >
> > ok, i will look. But this is existing code moved into a new function and
> > has been
> >
> > working fine for years. =20
>=20
>=20
> looked at print_null and switching to that results in a change in output=
=20
> for existing protodown
>=20
> attribute, so I plan to leave it as is for now.
>=20

Sure we should really try and have some consistency in the JSON output.
Maybe a JSON style guide is needed, I wonder if some heavy JSON user already
has one?
