Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5437D12F256
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 01:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbgACAoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 19:44:39 -0500
Received: from mail-40130.protonmail.ch ([185.70.40.130]:45997 "EHLO
        mail-40130.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgACAoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 19:44:39 -0500
Date:   Fri, 03 Jan 2020 00:44:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1578012277;
        bh=zxDKC+4AvN29xeDBmGoHmxwyQagX+YwdEZSXEikpxG8=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=c+BgxYLg2pTQcl8s8psX1b0mWt47WgutWSfnjtUoiS8Q0jYQC2fHh4YRtKMBzNbKw
         E8GiTubCW9FN5Npz6k3xuFLU13baEB50ju7tktOgU1sZ/6RvZrnKnx9Fot2nJuHABO
         Iayj5brhvxv6mtKnDrbDxOv1A/flaCTlI+vR1E6U=
To:     Stephen Hemminger <stephen@networkplumber.org>
From:   Ttttabcd <ttttabcd@protonmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Reply-To: Ttttabcd <ttttabcd@protonmail.com>
Subject: Re: [PATCH] fragment: Improved handling of incorrect IP fragments
Message-ID: <BRNuMFiJpql6kgRrEdMdQfo3cypcBpqGRtfWvbW8QFsv2MSUj_fUV-s8Fx-xopJ8kvR3ZMJM0tck6FYxm8S0EcpZngEzrfFg5w22Qo8asEQ=@protonmail.com>
In-Reply-To: <20200102112731.299b5fe4@hermes.lan>
References: <u0QFePiYSfxBeUsNVFRhPjsGViwg-pXLIApJaVLdUICuvLTQg5y5-rdNhh9lPcDsyO24c7wXxy5m6b6dK0aB6kqR0ypk8X9ekiLe3NQ3ICY=@protonmail.com>
 <20200102112731.299b5fe4@hermes.lan>
Feedback-ID: EvWK9os_-weOBrycfL_HEFp-ixys9sxnciOqqctCHB9kjCM4ip8VR9shOcMQZgeZ7RCnmNC4HYjcUKNMz31NBA==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_REPLYTO
        shortcircuit=no autolearn=no autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> You can not safely drop this check.
> With recursive fragmentation it is possible that the initial payload ends
> up exceeding the maximum packet length.

Can you give an example? What is "recursive fragmentation"?

In my previous tests, all fragment packets with a payload length exceeding =
65535 will be in the ip6_frag_queue

if ((unsigned int) end> IPV6_MAXPLEN)

Was discarded.


