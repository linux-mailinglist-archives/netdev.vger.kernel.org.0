Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF8A46653B
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 15:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240770AbhLBOaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 09:30:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41669 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347313AbhLBOaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 09:30:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638455199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=72KIeiz71nttfHl4Zl+KBXzz5nxM/kS16WCLB4E457s=;
        b=UR/5PtZUutcptjcGXWmvSDpgMpLTCz/v6EVsypsVSQl4Nn/dduD2SLJt2JFrWJlsksiP2p
        wPgvux7NYzC3ZxoNOUb2R0tk1eBNQ8MwokbZFGqgVQE8+g1Bd2tQAagtT0OhyvMFxmY4bV
        JQT1WAh4fO0n6YMS9CTTqawAbCC/X2A=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-463-wqk3yZPRO9CA4KfmP_7JxQ-1; Thu, 02 Dec 2021 09:26:37 -0500
X-MC-Unique: wqk3yZPRO9CA4KfmP_7JxQ-1
Received: by mail-io1-f72.google.com with SMTP id k125-20020a6bba83000000b005e7a312f86dso30098731iof.9
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 06:26:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=72KIeiz71nttfHl4Zl+KBXzz5nxM/kS16WCLB4E457s=;
        b=dXbPsISHG71918a3vYyKyafb56rdxIzVoESZuGxv8uO39tJkxUf+DS8M6d2UDMzYsm
         BkTunT4rHtCIAgyLZhlshJhefaMUtysfaRkS9E6uzHwrXaS9x9xI+CEEZRywgP+TX8vM
         SE/XcTlQzWSw5SdxmB+0rAc+j6swyqJPoZzqhUJGKGtQGmuG664EXaOg/NpFoYBIE08o
         sNO3QF3cyBFEY+pi6+C81n2xVKfI1ylPDyKIVt1ouvlbMy1tOjQ7d0Wa5sazDsRtTPm1
         awAaF2T1N3Ve69v51hZ+iQfL9Lkd7KuIV/qraIAg+Vowcx9pHEPtOTDQGMjoIi07CwxE
         k3+A==
X-Gm-Message-State: AOAM531Y2rJaltJMdCBZiLLoq65wvbKREAb4MJf8Q5kquB9xsxoCED5p
        I+Uqhw4Wooq8V/9sGtK7KPqWSUX7zXAc5WBIGAcUKuuhMNQCr3a5Bj1HFpehDCfkhXj3tnYyPuj
        uG2cy/6Gyvm3LauQcUMZWLvOHt4rJHRQl
X-Received: by 2002:a05:6e02:2149:: with SMTP id d9mr16742567ilv.312.1638455196908;
        Thu, 02 Dec 2021 06:26:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzgmUW9GRO6+Nk8Hvvy9ibUNEjSEA+m4n2eVPrAn9JiLExrrAIrCuodzA9emYtCCwsJ7NmxdouCtqf2gqAJdek=
X-Received: by 2002:a05:6e02:2149:: with SMTP id d9mr16742549ilv.312.1638455196753;
 Thu, 02 Dec 2021 06:26:36 -0800 (PST)
MIME-Version: 1.0
References: <CACT4oudChHDKecLfDdA7R8jpQv2Nmz5xBS3hH_jFWeS37CnQGg@mail.gmail.com>
 <beef3b28-6818-df7b-eaad-8569cac5d79b@gmail.com>
In-Reply-To: <beef3b28-6818-df7b-eaad-8569cac5d79b@gmail.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Thu, 2 Dec 2021 15:26:25 +0100
Message-ID: <CACT4oufaWTsvHEwi4vxcPtJLocGD2HZAaZfEMSei4ESF1amsnQ@mail.gmail.com>
Subject: Re: Bad performance in RX with sfc 40G
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, habetsm.xilinx@gmail.com,
        netdev@vger.kernel.org, Dinan Gunawardena <dinang@xilinx.com>,
        Pablo Cascon <pabloc@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Nov 18, 2021 at 6:19 PM Eric Dumazet <eric.dumazet@gmail.com> wrote=
:
> You could try to :
>
> Make the RX ring buffers bigger (ethtool -G eth0 rx 8192)
>
> and/or
>
> Make sure your tcp socket receive buffer is smaller than number of frames=
 in the ring buffer
>
> echo "4096 131072 2097152" >/proc/sys/net/ipv4/tcp_rmem

Thanks for the suggestion. Sadly, the results are almost the same.

> You can also try latest net-next, as TCP got something to help this case.
>
> f35f821935d8df76f9c92e2431a225bdff938169 tcp: defer skb freeing after soc=
ket lock is released

I'll try ASAP, but I will need some days. Thanks



--=20
=C3=8D=C3=B1igo Huguet

