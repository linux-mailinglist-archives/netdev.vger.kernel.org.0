Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 866846DC836
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 17:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjDJPLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 11:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjDJPLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 11:11:11 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E85935B7;
        Mon, 10 Apr 2023 08:11:07 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1a524c999d9so2053425ad.3;
        Mon, 10 Apr 2023 08:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681139467;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=46WfDNpEIQm7r1fBHGrMPutVkh7zMeNvKdiIKsFQezE=;
        b=P8iVdQRKO/pIhW4EmHCEeuiTPeO7KZGChqccMBtRJ9Yi6bxmTRDRhmGSXgL7NBb/ar
         9FYnkIY6c19+s4AKRkmOXNIkGKNR/FUSEmno0cFUfgcV/Md49qMRMVqYqVs8Jcg8zX24
         B5a0ZlmfzSzasQb1oWCOX1VZ4jdv7sVXUZo7pj6/BOYcNNbP0qnOLPX9Dk6dvoNXUJnm
         WsKriUdMx/Dw+SHPYUmDuGqhZ8KvXwNRlC6E8gHNw7IwwK7iEhoUxV0jt8cKX3GQLOCc
         6TPKKxY8cikrX+Rqvt/tZDchLeQY3w+mtUhy7XFID8hatd1plSEzK14uql8yp06Tcgy6
         LOfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681139467;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=46WfDNpEIQm7r1fBHGrMPutVkh7zMeNvKdiIKsFQezE=;
        b=vE8jP5BAkVK/QiB9udChixeWInvMvXnH43jfO4mkK0JYBXGRUM0JYefzuoUtYdawmn
         bZ0iBkeqnVeJnIjqIC7yy8gvd/pjMAsZY59HhECciZcSA6hmbI1eqmIg2PdTSXA8DCln
         2BZe6rsexkS3rnDoeSLB7wHRu9cGGkdJKdTyaJCn3UN22ujX5HIs0uiiZexSqeURo9T6
         aQzDXZc8cE+MLWfq4cMTOv9f1bhTWVWGsH9ftHozOM2sYCwdN+p9DQ4I6MX5ZLQ0ub7d
         Rocr9lJZU5WCcVRh3XDtvOmiuyA97jTrRki9VjCFxe0SYrJEAuVk2XG4fgEm+7CC2DxN
         4ysw==
X-Gm-Message-State: AAQBX9cDsb8jKeyL+KClJyVkuv2JxzL2GPQcOcbYvJyovZm++/rFJzvD
        2bKSFaRyZ+2YP5NsMnnCJtzUCLZmIM6jAOGn4EbS+oX+SCM=
X-Google-Smtp-Source: AKy350aFxvPZQ898QW0R398rQIwqpT2In48Zqfli/dVqETq7lz+R2ZRus1B65Cl4WGf9UwEI4114OqxeOozq28PhNhw=
X-Received: by 2002:a05:6a00:14cf:b0:593:fcfb:208b with SMTP id
 w15-20020a056a0014cf00b00593fcfb208bmr5237941pfu.3.1681139466309; Mon, 10 Apr
 2023 08:11:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAD4GDZwgOVn4dR2qiqrQWz-fw52aT9uyv22NCdo+hY4HJEgofQ@mail.gmail.com>
 <20230402225539.GA3388013@bhelgaas>
In-Reply-To: <20230402225539.GA3388013@bhelgaas>
From:   Donald Hunter <donald.hunter@gmail.com>
Date:   Mon, 10 Apr 2023 16:10:54 +0100
Message-ID: <CAD4GDZyVVoFmmBFY5hGQ9xbqRD=LzMfe7zVjDThiC589zT8uvQ@mail.gmail.com>
Subject: Re: [BUG] net, pci: 6.3-rc1-4 hangs during boot on PowerEdge R620
 with igb
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2 Apr 2023 at 23:55, Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> On Sat, Apr 01, 2023 at 01:52:25PM +0100, Donald Hunter wrote:
> > On Fri, 31 Mar 2023 at 20:42, Bjorn Helgaas <helgaas@kernel.org> wrote:
> > >
> > > I assume this igb NIC (07:00.0) must be built-in (not a plug-in card)
> > > because it apparently has an ACPI firmware node, and there's something
> > > we don't expect about its status?
> >
> > Yes they are built-in, to my knowledge.
> >
> > > Hopefully Rob will look at this.  If I were looking, I would be
> > > interested in acpidump to see what's in the DSDT.
> >
> > I can get an acpidump. Is there a preferred way to share the files, or just
> > an email attachment?
>
> I think by default acpidump produces ASCII that can be directly
> included in email.  http://vger.kernel.org/majordomo-info.html says
> 100K is the limit for vger mailing lists.  Or you could open a report
> at https://bugzilla.kernel.org and attach it there, maybe along with a
> complete dmesg log and "sudo lspci -vv" output.

Apologies for the delay, I was unable to access the machine while travelling.

https://bugzilla.kernel.org/show_bug.cgi?id=217317
