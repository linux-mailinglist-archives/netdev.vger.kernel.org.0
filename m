Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 756A4E53DB
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 20:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfJYSoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 14:44:05 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35656 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfJYSoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 14:44:05 -0400
Received: by mail-qt1-f195.google.com with SMTP id m15so4784418qtq.2
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 11:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=D4dmr/FwW9VlcK6RBYZhOGjwnq64VD9EqyyHS6ogqOM=;
        b=UOOcfZYQc3MD7xe+sSRBlJttLem25EsABNbIOS/IRuxbDl9ziaYQd4PKPvU0Tk9KFJ
         F8evUUyYzeaKwVtXdjH3DY6grkwBypmKYCyFiTV1V2hPhkg//BMMWJ7X62mbDVS6FnwE
         7CS4WYy6RKRdIoJKW1GVlBgXNa3QJFdXqtUBzasfdyZO6RU3OzP0QU8XVBI7eljCK2lb
         vr3aPQuHiE7DDBMzP2QkRGJR8i0MHPIcYh+co6xjCr0zJO8AnXgjHMa+JMVmHRAEs6lS
         /lZLTFpvkfMnStC+Sf+Jy7UWR6+3A9bkmWbFivWYY7QjvMG1CG67+p54ehIYiWXQBMTG
         HK/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=D4dmr/FwW9VlcK6RBYZhOGjwnq64VD9EqyyHS6ogqOM=;
        b=EC29qAwqL1soXDGKI4zIH5iOAnEar7ttRNthQUNC1Mu0JcL0Pz+MKalFGtB86MnCpe
         pqMrxptRhzKYcRGi8jGAVRJ9P95VihJ95lenuY9mOwSck3j5kfaoTeNgab2nZ7uoCqAK
         MDIerggakju9ZVkzWePWi6A9MuoBgXmxRNRJBqEGQyHEK717HRY89A0hfz6rJCKLBWBc
         ISDHe0h9pGBdGbXkEqlUPJyOXpothWL+cdI2vfkZ0JDyGEE0WEdnIPCRUGlQGrPmHqLc
         EDB7M2dHvR1waEbZ0YxJQpcl0+K7wd24OICUl4xhEQnaubDfeCBr87vftHv2Bv+VozKH
         FlFg==
X-Gm-Message-State: APjAAAX8x1A7HN6Kf4oc12vIN1P3Lf36COsRMQb9r60vG8I04I3wXHu1
        w28OuxGJzqECEKPmdulCdTU=
X-Google-Smtp-Source: APXvYqwZMdyot+X7Zyoy66PM+Nhx/RLQupAzlTI86lIJX/wtJFOlesKwy549ZM2tdZCcZI3Zp1DSHA==
X-Received: by 2002:ac8:3209:: with SMTP id x9mr4008588qta.293.1572029044693;
        Fri, 25 Oct 2019 11:44:04 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id k13sm1465635qki.40.2019.10.25.11.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 11:44:03 -0700 (PDT)
Date:   Fri, 25 Oct 2019 14:44:02 -0400
Message-ID: <20191025144402.GD1371059@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        andrew@lunn.ch, davem@davemloft.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH net-next 2/2] net: dsa: bcm_sf2: Wire up MDB operations
In-Reply-To: <20191024194508.32603-3-f.fainelli@gmail.com>
References: <20191024194508.32603-1-f.fainelli@gmail.com>
 <20191024194508.32603-3-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Oct 2019 12:45:08 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
> Leverage the recently add b53_mdb_{add,del,prepare} functions since they
> work as-is for bcm_sf2.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
