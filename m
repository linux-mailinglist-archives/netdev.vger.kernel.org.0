Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7974567BDFD
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 22:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236433AbjAYVSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 16:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236514AbjAYVSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 16:18:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7742768A
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 13:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674681449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HijArdmo1kZCu+7/yRP/icTQe2834XFOWriaKb7rLqk=;
        b=THwbctfrEQStdkHaZg708RH6w0sR8eP9H0G1N5fSq3Ui6bQxLIrtNvQqggX+U7XiTyVbTs
        tUHigPZb1iqCGigjWh5CSLJ8s22m/9s0p3EMVhPGZqLhTvHwEaBKFRRdD0J519nTy1jWnV
        P88/UAIdtD7Dp6ciAdYwk5Ep+aX9dZM=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-528-FIMS1xAxOd-pO09IQ8KbVQ-1; Wed, 25 Jan 2023 16:17:28 -0500
X-MC-Unique: FIMS1xAxOd-pO09IQ8KbVQ-1
Received: by mail-qv1-f70.google.com with SMTP id ff3-20020a0562140bc300b00534ec186e17so10018686qvb.14
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 13:17:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HijArdmo1kZCu+7/yRP/icTQe2834XFOWriaKb7rLqk=;
        b=ANWdJHYQTJShg5ZFJJymyf230L71lvotZPBiDA3aUgnaiJAOnZtlJR+5HhzQpseh4D
         obU7f3rw/sSQsDqOluhhYFrYwM86Xi2VMoWr6EL496jqpJaOX+MKahCnjAqFbE0sdMW5
         Q9QD5S//78mNYnCTjBDdBoQ6+aqHyqRCxNMiX/lESs6TKPQKsZLWkIA4ebOi3Oyb8AQm
         vEk9NiBcckzHw2o/BiB76vCkVWN9reqIw3gWEEpFixiiyPIm3bjm653gZtkljTrv0njF
         oV3SNvpeO9mW3+uCcyuHqjS2wSXRDXkL+Y4Y8YuCPC1sFN4ex0atns9vl1vTyi16cqc6
         aNAg==
X-Gm-Message-State: AO0yUKVkyrLGaLPyhXF9rkXTKrAIERxc3r6pCCVXE92lh39srZmetFkB
        Bynz1dBfj012HNmH9bA4dAvdswJTwmqu2vdIyb+A1cmWdCxcuhkjCuUYBejrfS4UcspA2VIa1Au
        xLOcNRc6KHmvBkkTR
X-Received: by 2002:ac8:4e45:0:b0:3a8:84f:1d3a with SMTP id e5-20020ac84e45000000b003a8084f1d3amr142062qtw.9.1674681448082;
        Wed, 25 Jan 2023 13:17:28 -0800 (PST)
X-Google-Smtp-Source: AK7set8FScXzuuELhG8mHg12y0e2uTWXhAnZY6R7CQSxvKI4F7FENhKaCahn4KN5+XJRTm8wOeO34Q==
X-Received: by 2002:ac8:4e45:0:b0:3a8:84f:1d3a with SMTP id e5-20020ac84e45000000b003a8084f1d3amr142029qtw.9.1674681447814;
        Wed, 25 Jan 2023 13:17:27 -0800 (PST)
Received: from ?IPv6:2603:7000:9400:fe80::318? (2603-7000-9400-fe80-0000-0000-0000-0318.res6.spectrum.com. [2603:7000:9400:fe80::318])
        by smtp.gmail.com with ESMTPSA id a1-20020a05620a438100b006fc2b672950sm4262722qkp.37.2023.01.25.13.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 13:17:27 -0800 (PST)
Message-ID: <3e9dc325734760fc563661066cd42b813991e7ce.camel@redhat.com>
Subject: Re: [PATCH net-next 0/5] tls: implement key updates for TLS1.3
From:   Simo Sorce <simo@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Apoorv Kothari <apoorvko@amazon.com>
Cc:     sd@queasysnail.net, borisp@nvidia.com, dueno@redhat.com,
        fkrenzel@redhat.com, gal@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com
Date:   Wed, 25 Jan 2023 16:17:26 -0500
In-Reply-To: <20230125105743.16d7d4c6@kernel.org>
References: <Y8//pypyM3HAu+cf@hog>
         <20230125184720.56498-1-apoorvko@amazon.com>
         <20230125105743.16d7d4c6@kernel.org>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-01-25 at 10:57 -0800, Jakub Kicinski wrote:
> On Wed, 25 Jan 2023 10:47:20 -0800 Apoorv Kothari wrote:
> > > We'll need to keep the old key around until we know all the records
> > > using it have been fully received, right?  And that could be multiple
> > > old keys, in case of a quick series of key updates. =20
> >=20
> > Why does the hardware implementation need to store old keys? Does the n=
eed
> > for retransmitted data assume we are operating in TLS_HW_RECORD mode an=
d
> > the hardware is also implementing the TCP stack?
>=20
> We're talking about the Tx direction, the packets are queued to the
> lower layers of the stack unencrypted, and get encrypted by the NIC.
> Until TCP gets acks for all the data awaiting offloaded crypto - we
> must hold onto the keys.

Is this because the NIC does not cache the already encrypted outgoing
packets?

If that is the case is it _guaranteed_ that the re-encrypted packets
are exactly identical to the previously sent ones?

If it is not guaranteed, are you blocking use of AES GCM and any other
block cipher that may have very bad failure modes in a situation like
this (in the case of AES GCM I am thinking of IV reuse) ?

>=20
> Rx direction is much simpler indeed.
>=20
> > The TLS RFC assumes that the underlying transport layer provides reliab=
le
> > and in-order deliver so storing previous keys and encrypting 'old' data
> > would be quite divergent from normal TLS behavior. Is the TLS_HW_RECORD=
 mode
> > processing TLS records out of order? If the hardware offload is handlin=
g
> > the TCP networking stack then I feel it should also handle the
> > retransmission of lost data.
>=20
> Ignore TLS_HW_RECORD, it's a ToE offload, the offload we care about
> just offloads encryption.
>=20

--=20
Simo Sorce
RHEL Crypto Team
Red Hat, Inc



