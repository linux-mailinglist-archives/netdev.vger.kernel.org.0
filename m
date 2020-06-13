Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9FB61F83C0
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 16:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgFMOoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 10:44:14 -0400
Received: from mta-out1.inet.fi ([62.71.2.202]:54174 "EHLO johanna1.inet.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726323AbgFMOoO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Jun 2020 10:44:14 -0400
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgeduhedrudeifedgkeduucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuuffpveftnecuuegrihhlohhuthemuceftddtnecunecujfgurhepuffhvfhfkffffgggjggtgfesthekredttdefjeenucfhrhhomhepnfgruhhrihculfgrkhhkuhcuoehlrghurhhirdhjrghkkhhusehpphdrihhnvghtrdhfiheqnecuggftrfgrthhtvghrnhepkedutdfghfeuueeitdeghfdutdefueejlefgteegteegtdejledtjedvheeujeetnecuffhomhgrihhnpehmrghnjhgrrhhordhorhhgnecukfhppeekgedrvdegkedrfedtrdduleehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehhvghloheplgduledvrdduieekrddurddukedvngdpihhnvghtpeekgedrvdegkedrfedtrdduleehpdhmrghilhhfrhhomhepoehlrghujhgrkhdqfeesmhgsohigrdhinhgvthdrfhhiqecuuefqffgjpeekuefkvffokffogfdprhgtphhtthhopeeouggrvhgvmhesuggrvhgvmhhlohhfthdrnhgvtheqpdhrtghpthhtohepoehhkhgrlhhlfigvihhtudesghhmrghilhdrtghomheqpdhrtghpthhtohepoehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrgheq
Received: from [192.168.1.182] (84.248.30.195) by johanna1.inet.fi (9.0.019.26-1) (authenticated as laujak-3)
        id 5E1C39AA791A4D3F; Sat, 13 Jun 2020 17:44:08 +0300
Subject: Re: r816x driver
From:   Lauri Jakku <lauri.jakku@pp.inet.fi>
To:     hkallweit1@gmail.com, davem@davemloft.net, netdev@vger.kernel.org
References: <9c3fb65c-ff2d-a21e-98db-c5798dc9586e@pp.inet.fi>
Message-ID: <3538ceba-5bb6-7b03-ac36-1bf23c29f771@pp.inet.fi>
Date:   Sat, 13 Jun 2020 17:43:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <9c3fb65c-ff2d-a21e-98db-c5798dc9586e@pp.inet.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 13.6.2020 1.46, Lauri Jakku wrote:
> Hi,
>
> As you may recall i've started to debug r816x driver: Why it does not 
> work, and i'm allmost
>
> certain there is something fishy in probeing ... 1st try always fails, 
> and second try with
>
> my patch seems to work ok.
>
>
> https://forum.manjaro.org/t/re-r8168-kernel-5-6-3-driver-broken/147727/2
>
>
> Something is not done similar way compared to 1st and 2nd load of the 
> module. I pin pointed,
>
> or have a clue, that a line from drivers/net/phy/phy_device.c witch is 
> not executed when
>
> loading first time:
>
> static int phy_probe(struct device *dev)
> {
>         struct phy_device *phydev = to_phy_device(dev);
>         struct device_driver *drv = phydev->mdio.dev.driver;
>         struct phy_driver *phydrv = to_phy_driver(drv);
>         int err = 0;
>
>         phydev->drv = phydrv; <--- This is never done in probe of 
> r8169_main.c
>
>
> That line is not executed when driver is loaded with modprobe, but 
> when load->remove->reload
>
> cycle is done, it is ok. I have no clue now where to look, but when i 
> got time i'll start
>
> debugging some more.
>
>
>


> --Lja
>
