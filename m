Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610D0482004
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 20:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241987AbhL3Tsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 14:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239877AbhL3Tsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 14:48:53 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56161C061574;
        Thu, 30 Dec 2021 11:48:53 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id v11so52331202wrw.10;
        Thu, 30 Dec 2021 11:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8IdNS7T3UcLg0e/sYRv7oAlgpubQqWF3kQNzPbkd3yU=;
        b=IFh9PlCWbpYVBu1k+wv2lvyXvynXGAOo1vnM4wXNujh85PmS3Gb0j8oNAJRSII6Td3
         fQgt+lgmGKN1dCrnmTmqFoGOyglnF353JUTQkhI9XoGLeMfI6MqB36U1PKq6iwm234Wf
         dyUg/zSEyBZ7f52me6GGdVa7uHGdF46gyLhOxFbdMHf6pnv1HzCLACCNzFas8n7rZFTE
         Ld8w771NfBmnyts6AW3qn0JtVtg0qKOVpzIRnd2QKh85d9fO3Z71wFxnO6RWmxOWKfeR
         7555C2PMAFO3P12bO7oxlsvrrif+PTBhfQxKh6TBiCPZDrVE/ibbIRP1LheUTMMGFPWB
         H7bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8IdNS7T3UcLg0e/sYRv7oAlgpubQqWF3kQNzPbkd3yU=;
        b=ZitJlFNAf37APc8n5NCTF9aqZla6KD/HfAim5apjtRAEuwKbt2ep1jVB8PgXz0+DmB
         9pX0IDglQxgG69DodovQeDl20gDJP1CqtqwngVQWQsJfPuGTIAvgSFS3dYnbNSC9DNNl
         23QhsAzyxK8qVaDPoCiZokVp4KPSnmyS3iRMjNYw2wh1R55LnreqY1vpClILHkY2EC8E
         uXcxkyKZLQWKeYy5hDXSQUEZ80vnMOgxDUUXuVY414ixQOIPf1LIHnQtA4BsaBqawWRX
         7aEXpNZsv31jEosdtPAznYe6eHqFl4N+7WjxxS0zSs+IC34hOHfPwQhybfJqRv9Ki0j9
         yEzQ==
X-Gm-Message-State: AOAM530NsTklYOsoRMtutftAx7BIcTju7R4SoItzMhxUrfnBS3r2VuxS
        y8kbSWL1aVSWpwnbw9K8YCAyx5dviDrWt6HEwf4+KG5u
X-Google-Smtp-Source: ABdhPJzMcm/8iii5owGOe5SeDzBS6uWKT1g4Q0FHlV+E7kWxOVk+1/dvdjuP5P0m85lPN0Q7ulZdjTYjigxkF2NsZa8=
X-Received: by 2002:a05:6000:186e:: with SMTP id d14mr27344766wri.205.1640893731942;
 Thu, 30 Dec 2021 11:48:51 -0800 (PST)
MIME-Version: 1.0
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
 <20211222155743.256280-18-miquel.raynal@bootlin.com> <CAB_54W7o5b7a-2Gg5ZnzPj3o4Yw9FOAxJfykrA=LtpVf9naAng@mail.gmail.com>
 <SN6PR08MB4464D7124FCB5D0801D26B94E0459@SN6PR08MB4464.namprd08.prod.outlook.com>
In-Reply-To: <SN6PR08MB4464D7124FCB5D0801D26B94E0459@SN6PR08MB4464.namprd08.prod.outlook.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Thu, 30 Dec 2021 14:48:41 -0500
Message-ID: <CAB_54W6ikdGe=ZYqOsMgBdb9KBtfAphkBeu4LLp6S4R47ZDHgA@mail.gmail.com>
Subject: Re: [net-next 17/18] net: mac802154: Let drivers provide their own
 beacons implementation
To:     David Girault <David.Girault@qorvo.com>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        Romuald Despres <Romuald.Despres@qorvo.com>,
        Frederic Blain <Frederic.Blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 30 Dec 2021 at 12:00, David Girault <David.Girault@qorvo.com> wrote:
>
> Hi Alexander,
>
> At Qorvo, we have developped a SoftMAC driver for our DW3000 chip that will benefit such API.
>
Do you want to bring this driver upstream as well? Currently those
callbacks will be introduced but no user is there.

> To be short, beacon sending is controller by our driver to be synchronized chip clock or delayed until
> other operation in progress (a ranging for example).
>

ok.

- Alex
