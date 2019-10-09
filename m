Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35F86D108A
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 15:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731144AbfJINsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 09:48:54 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57137 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729883AbfJINsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 09:48:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570628933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oL/XrZH1ikTD6P6rpWO457HTENd5c2wTrF29IM78NRw=;
        b=bN4Op87PHheDjZa1xAqw+I4sejXdsSgB50yDiLZ0JIrQbuFUV8b/RLP+QK80C4DrIWH3Mh
        lY6r/PtwK0gP5uPzzGkbkAdgbAogkMC57NLqVYHarUVJBFd4WHoeamoUXwh8qAr1gU2Mh4
        c7O8qmACS4LJErx6j3Cw97uzTuZyRME=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-M5PY6-TQOJCkb1zyNG1D_w-1; Wed, 09 Oct 2019 09:48:51 -0400
Received: by mail-wr1-f70.google.com with SMTP id j7so1144213wrx.14
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 06:48:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VyQvhDIjTJUCBS7FbKutKN0cSsEdB4JBk/+K0U8A8KQ=;
        b=fLya9XsCb8lj73zkITQhktU8ipmc0XfH+CoZ3w6qcI3bTSgbunu7ohjmx8zV5GVj93
         Qhb5xZplJzvDqDTaTYrrT8/OJOHAGSu7Zog7VEpcPvgX6T4GVnEa8i1yksMs6gJlIVzX
         XDbtxfwAqLSDncnNpONhNhIP26hJ4QHRZC04eY4Jw1VMRqCSYByyowxD2lq2oDXmDp+3
         r2f2LSzLkwjUmeczLsiLm+PFnD3BZc8UT8tjdx/ye649GKWBRPTNLe9bkH85WMyTG7dm
         AJtk/ReqjTOTGz4dtQ6rtIMCo3TuHCW8Dzs59h4i9UH73KW2y8FTZpa1tVp7szPZ78Wn
         n1DQ==
X-Gm-Message-State: APjAAAV9Fxw/KGWmZkqpbNvknX4LrYP+CmPmDtqNGTUCm+/U4u/h8lio
        98YUJIMfy7yZOGVnQc3UuTnaMnCtEuTnlRQFU27d3AlQMlSuWZrVXSQcxm7deSY9HD/L86XhqCX
        e16ZRq3h6+lG+gkC7
X-Received: by 2002:a5d:5589:: with SMTP id i9mr3128624wrv.129.1570628929977;
        Wed, 09 Oct 2019 06:48:49 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxmDk+Y1hBWQEY46aDWNnpk9mmTO2JbHM2AqqdIa5tw405OdvhQrGar4chIdOBolCjlnd2dkA==
X-Received: by 2002:a5d:5589:: with SMTP id i9mr3128613wrv.129.1570628929853;
        Wed, 09 Oct 2019 06:48:49 -0700 (PDT)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id b144sm3537562wmb.3.2019.10.09.06.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 06:48:49 -0700 (PDT)
Date:   Wed, 9 Oct 2019 15:48:47 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] netns: fix NLM_F_ECHO mechanism for RTM_NEWNSID
Message-ID: <20191009134847.GB17373@linux.home>
References: <20191008231047.GB4779@linux.home>
 <20191009091910.4199-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
In-Reply-To: <20191009091910.4199-1-nicolas.dichtel@6wind.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: M5PY6-TQOJCkb1zyNG1D_w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 09, 2019 at 11:19:10AM +0200, Nicolas Dichtel wrote:
> The flag NLM_F_ECHO aims to reply to the user the message notified to all
> listeners.
> It was not the case with the command RTM_NEWNSID, let's fix this.
>=20
Acked-by: Guillaume Nault <gnault@redhat.com>
Tested-by: Guillaume Nault <gnault@redhat.com>

