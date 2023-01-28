Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34AB167F7C4
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 13:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbjA1MH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 07:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbjA1MH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 07:07:26 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1203779604
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 04:07:25 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1674907643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4c+Bnams4d5PM0hzsVjEUA4bq+u2AJbJSHTSCO8rFoo=;
        b=T9YxgZ6MIVEhkTY9S8pgRjXcoR3Nw3PBRfCAFaxwNHo0d7aggQc7mrGa7MdITj3PgyqG2c
        sY8OAjd6VEW/u6aVHkOllIUVwAsG+qgcOs5IvmGY6F+BcS2U2k341zx99XVOtt6LuzQBRF
        rrNq62atvfp9ZBvwBUti0gEzaCXxj49vNWMsnMmbSA24GPBgo3E+/O1WtYrThRy072k9Ne
        P8448Mr6hqZN+M1ws59WW3sJwrK3OGd40tU7mSAtb2cKDxuvrk7WuoGTth6FfhVthElfOk
        xL/vAJ0uWwsFL3ibrRHXd5eHae/Q830XzCVvoS7Tsx+2qzAFhX1AXuNNuCznrQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1674907643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4c+Bnams4d5PM0hzsVjEUA4bq+u2AJbJSHTSCO8rFoo=;
        b=9C2uPV2l2u2bmxTR6jiBdaN0yo4a3nSO71HYNSHHrfn77+Xr3PlK5imC213F83rCRpEXJn
        4bDX93ELuqmHJRBw==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [RFC PATCH net-next 15/15] net/sched: taprio: don't segment
 unnecessarily
In-Reply-To: <20230128010719.2182346-16-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
 <20230128010719.2182346-16-vladimir.oltean@nxp.com>
Date:   Sat, 28 Jan 2023 13:07:22 +0100
Message-ID: <87r0veuakl.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Sat Jan 28 2023, Vladimir Oltean wrote:
> Improve commit 497cc00224cf ("taprio: Handle short intervals and large
> packets") to only perform segmentation when skb->len exceeds what
> taprio_dequeue() expects.
>
> In practice, this will make the biggest difference when a traffic class
> gate is always open in the schedule. This is because the max_frm_len
> will be U32_MAX, and such large skb->len values as Kurt reported will be
> sent just fine unsegmented.
>
> What I don't seem to know how to handle is how to make sure that the
> segmented skbs themselves are smaller than the maximum frame size given
> by the current queueMaxSDU[tc]. Nonetheless, we still need to drop
> those, otherwise the Qdisc will hang.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPVD/oTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgrrcD/9nrXAZ8bgLEiY6SJLEpUqpxIluhTFv
QFggVAXAj24zi1WuP5TzRU2XCLqE96SWJjCF7YlLvepnYLMimOvtImeIn0z5Tu43
fn2lsRAh545Uu6cShxPvLvISYeX9t8bdU5wz/b3QTug9/QU/Fa307UJnIPjRiuWs
JCoe75NozWwYO7q+Xp6RD6jaUsM60ZMBkz6l4jYON/VFYej87OjpFFcYBwXf0a/Y
ESAStwRtCIxzuBd4K91r1rQr888OAb+EQQ04AikfnJGBOmtFAWefQFXJHX3fYKfB
DEQnKr1B5bJ5nNLqlFXeRKrAQOZQKa5v+tKcMwUdlO6BHDm30sVyzW+PimXCcYJp
VSwm5oWjIAw5XINuIjyF1SpSgYjgwWrInFvCmNMlWxEylkRYroagHxzRgLeCQco/
nN7qoSlW9J9davhH1mpMuE4q8aicnTcutHAWHLtRyQS17Zyp8s8exZTGbMu0U028
UmxKfxSd8H0C3iTu68gnnr8+3+aCMtrYk6MXMsebdhF+v/Cq67bbkbCItmfYQn53
EcDXh5I6dbH0SDwTbxGEzO/3/SmGFRz0+LlakrSu7lJgfcji/jNTXI+ypOi/j3F9
upedgJ9PGJrAy7/e5jZNmXzZSZnvMBUmiRGT7ttHusJaEymdZ2tWcrBZDEl44kbx
jF8xX594SRZNLw==
=cYK2
-----END PGP SIGNATURE-----
--=-=-=--
