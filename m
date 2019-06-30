Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCEC5B19F
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 22:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfF3Us1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 16:48:27 -0400
Received: from hermes.domdv.de ([193.102.202.1]:2094 "EHLO hermes.domdv.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726669AbfF3Us0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 16:48:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=domdv.de;
         s=dk3; h=Content-Transfer-Encoding:MIME-Version:Content-Type:Date:Cc:To:From
        :Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KLMfJAYOt+bluwW3zD/2WbUalnw22h08kgnNPyko+9M=; b=MpP95/jexteulOKdOs02cJBM3R
        lkP0xk6pAzPq4xOmMCH1dSbeHKuJx/i5QKNXxxLN6H73SfAUOLZHLu/HVK2Q0fNiXCNmp681fVWqm
        cVDgW80fcAaxcI58V4RlFPqPjF1mq2p1tOmzYo3jyEFN4Fo7dxRhOADjT23i0WKzEtS0=;
Received: from [fd06:8443:81a1:74b0::212] (port=4326 helo=castor.lan.domdv.de)
        by zeus.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <ast@domdv.de>)
        id 1hhgid-0005SF-DQ; Sun, 30 Jun 2019 22:46:39 +0200
Received: from woody.lan.domdv.de ([10.1.9.28] helo=host028-server-9.lan.domdv.de)
        by castor.lan.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <ast@domdv.de>)
        id 1hhgid-0007zY-8U; Sun, 30 Jun 2019 22:46:39 +0200
Message-ID: <04d1ca9ff24de717746b5e21573656f6cb7069d6.camel@domdv.de>
Subject: [PATCH net 0/2] macsec: fix some bugs in the receive path
From:   Andreas Steinmetz <ast@domdv.de>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Date:   Sun, 30 Jun 2019 22:46:38 +0200
Organization: D.O.M. Datenverarbeitung GmbH
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes some bugs in the receive path of macsec. The first
is a use after free when processing macsec frames with a SecTAG that
has the TCI E bit set but the C bit clear. In the 2nd bug, the driver
leaves an invalid checksumming state after decrypting the packet.

This is a combined effort of Sabrina Dubroca <sd@queasysnail.net> and me.


