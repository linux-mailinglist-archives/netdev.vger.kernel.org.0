Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF295D8D2
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfGCA3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:29:55 -0400
Received: from hermes.domdv.de ([193.102.202.1]:3922 "EHLO hermes.domdv.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727204AbfGCA3y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 20:29:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=domdv.de;
         s=dk3; h=Content-Transfer-Encoding:MIME-Version:Content-Type:Date:Cc:To:From
        :Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=i+jGNTE1m3VX3ZCqHy8CGDRuej2Jw/b3JvRaqhTRf+M=; b=P2T2EJETQuU25tODtaZJK9k/Lk
        12oI9Ifw3XzTQSZ8V0WAxlAx9UfqzLdVFihv21uix7nmsZ+Z0NSri+7l4di/82Z6RSomv+mHpql15
        pmgTOvKGSBElJXaBPOb7WK23uZqtdyE7vaRPidNiQ38/SeDHp4ZrHL7yRhQI4tJ82bOc=;
Received: from [fd06:8443:81a1:74b0::212] (port=1832 helo=castor.lan.domdv.de)
        by zeus.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <ast@domdv.de>)
        id 1hiPis-0005AV-NR; Tue, 02 Jul 2019 22:49:54 +0200
Received: from woody.lan.domdv.de ([10.1.9.28] helo=host028-server-9.lan.domdv.de)
        by castor.lan.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <ast@domdv.de>)
        id 1hiPis-0005kV-IJ; Tue, 02 Jul 2019 22:49:54 +0200
Message-ID: <7ec44dd08280f0b32dcf18aa35f687fc227c0197.camel@domdv.de>
Subject: [PATCH net-next 0/3 v2] macsec: a few cleanups in the receive path
From:   Andreas Steinmetz <ast@domdv.de>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Date:   Tue, 02 Jul 2019 22:49:54 +0200
Organization: D.O.M. Datenverarbeitung GmbH
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset removes some unnecessary code in the receive path of the
macsec driver, and re-indents the error handling after calling
macsec_decrypt to make the post-processing clearer.

This is a combined effort of Sabrina Dubroca <sd@queasysnail.net> and me.

Change in 3/3:

The patch now only moves the IS_ERR(skb) case under the block where
macsec_decrypt() is called, but not the call to macsec_post_decrypt().

