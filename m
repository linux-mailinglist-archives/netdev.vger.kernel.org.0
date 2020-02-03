Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B76E150208
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 08:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbgBCHmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 02:42:12 -0500
Received: from mail-oi1-f172.google.com ([209.85.167.172]:42248 "EHLO
        mail-oi1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbgBCHmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 02:42:12 -0500
Received: by mail-oi1-f172.google.com with SMTP id j132so13801846oih.9
        for <netdev@vger.kernel.org>; Sun, 02 Feb 2020 23:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=yg/wyCxXq8YZHNzJ8dsfVrkQkmbydQc6ARYkz/xIlE4=;
        b=AgIJ/ru07cQE0F8oPh3z8XLKq6UZvtRYvh1l6vLBtICtnIex273md0pgT9fhQ+IgeX
         U/NQddqQDqpXBbRBu1OLvWROwVhaldM07J03pHZxlL9NpJWM89jfPPeP4DCwMjy0ppRK
         sn1YE0pAsu+3hEMMYE5txff0OTfWqBfXLXHus=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=yg/wyCxXq8YZHNzJ8dsfVrkQkmbydQc6ARYkz/xIlE4=;
        b=Ntr/tg7dHMLpkEJxBnYigDebbCrylsX7tJFu30c3p298nTXkdyUycM5llAHMpq0RQJ
         FbB99+w3w7PWwxZHahB1+Rct/tgFhwCJCnHNuw35EViLFAL88dIMoqy4F71MP4NZXbdz
         ff6fwtNFChKExPyWBEv/N530YSYn4xvhZlgJXR6/wcyKqKXrTB4+oehOmo2IkiHgrmNI
         Ngw1xYer3GjFn3CJcefgiozPXVuhZ4ycg+ffPIw0jY16bvVwSKSrCPOf6HRafafhj2GN
         A/rceDiu80GRsO+E6q2C658vZl9NL1ebFeD2OEQwUDQC4M+yzNiYheq+CpdVPO7aPOoU
         f15g==
X-Gm-Message-State: APjAAAXS8pkQ4r/F9XPc2UDZb90NEtFo7PkFHe6Sq24DlIVJuG9N2eZg
        0Juhty9LDQWWVatXROytDtbNlJm8m5cqpAzUVc+YburMEA0=
X-Google-Smtp-Source: APXvYqxMloF9bo2+bzstf5dy/VHshs6E6zyyW5QEyXrNgLsJgazP3yW8qsuSUDKTxJj/UHRXUqZRiDcMfy7ZPwj5h7E=
X-Received: by 2002:aca:5303:: with SMTP id h3mr13349839oib.109.1580715731632;
 Sun, 02 Feb 2020 23:42:11 -0800 (PST)
MIME-Version: 1.0
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Sun, 2 Feb 2020 23:42:00 -0800
Message-ID: <CACKFLi=8uYrOx9GM412hArXzFHZW7WpD3P4F_hT5S0bgf_YTjA@mail.gmail.com>
Subject: [stable] bnxt_en: Move devlink_register before registering netdev
To:     David Miller <davem@davemloft.net>
Cc:     Netdev <netdev@vger.kernel.org>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David, I'd like to request this patch for 5.4 and 5.5 stable kernels.
Without this patch, the phys_port_name may not be registered in time
for the netdev and some users report seeing inconsistent naming of the
device.  Thanks.

commit cda2cab0771183932d6ba73c5ac63bb63decdadf
Author: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Mon Jan 27 04:56:22 2020 -0500

    bnxt_en: Move devlink_register before registering netdev
